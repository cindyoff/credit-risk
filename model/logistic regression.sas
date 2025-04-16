/* logistic regression without categories */
proc logistic data=Base_projet_final descending;
class investor_orig_time / param=ref;
model default_time = LTV_time first_time orig_time mat_time hpi_time hpi_orig_time uer_time gdp_time investor_orig_time
/ selection=STEPWISE slentry=0.05 slstay=0.05;
output out=Predictions P=prob_defaut;
run;

/* logistic regression with the categories created */
proc logistic data=Base_projet_final;
class LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time / PARAM=REF;
model DEFAUT (event='1') = LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time;
run;

proc logistic data=Base_projet_final PLOTS(ONLY)=ROC;
class LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time
FICO_orig_time_class / PARAM=REF;
model default_time (EVENT='1') = LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time
FICO_orig_time_class;
run;

data Base_projet_final;
set Base_projet_final;
correct_class = (predicted_class = default_time);
run; 

/* predictions, 0.4 */
data Base_projet_final;
set Base_projet_final;
predicted_class = (pred >= 0.4); /* Tester avec un seuil de 0.4 */
run;

data pred_logit_class;
set pred_logit_class;
predicted_class = (pred >= 0.5);
run;

proc freq data=pred_logit_class;
tables default_time*predicted_class / chisq ;
run; 

data pred_logit_class;
set pred_logit_class;
correct_class = (default_time = predicted_class);
run;

/* generating the mean value of predictions */
proc means data=pred_logit_class mean ;
var correct_class;
run;

/* predictions, 0.5 */
output out=pred_logit_class P=pred;
run;

data pred_logit_class;
set pred_logit_class;
predicted_class = (pred >= 0.5);
run;

proc freq data=pred_logit_class;
tables default_time*predicted_class / chisq ;
run; 

data pred_logit_class;
set pred_logit_class;
correct_class = (default_time = predicted_class);
run;

/* generating the mean value of predictions */
proc means data=pred_logit_class mean ;
var correct_class;
run;

/* ROC curve */
proc logistic data=Base_projet_final;
model default_time (event='1') =
LTV_time first_time orig_time mat_time
hpi_time uer_time gdp_time investor_orig_time;
output out=predictions P=predicted_prob;
roc 'Model';
run;

/* confusion matrix */
proc freq data=Base_projet_final;
tables default_time * predicted_class / norow nocol nopercent chisq ;
run; 

proc means data=Base_projet_final mean ;
var correct_class;
run; 

/* correct classification rate */
data pred_logit_class;
set pred_logit_class;
correct_class = (default_time = predicted_class);
run;
proc means data=pred_logit_class mean ;
var correct_class;
run;
