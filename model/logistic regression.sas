/* logistic regression */
proc logistic data=Base_projet_final descending;
class investor_orig_time / param=ref;
model default_time = LTV_time first_time orig_time mat_time hpi_time hpi_orig_time uer_time gdp_time investor_orig_time
/ selection=STEPWISE slentry=0.05 slstay=0.05;
output out=Predictions P=prob_defaut;
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







PROC LOGISTIC DATA=Base_projet_final;
CLASS LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time / PARAM=REF;
MODEL DEFAUT (EVENT='1') = LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time;
RUN;
PROC LOGISTIC DATA=Base_projet_final PLOTS(ONLY)=ROC;
CLASS LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time
FICO_orig_time_class / PARAM=REF;
MODEL default_time (EVENT='1') =
LTV_time_class first_time_class orig_time_class mat_time_class
hpi_time_class uer_time_class gdp_time_class investor_orig_time
FICO_orig_time_class;



/* Regroupement des classes apres analyse des WoE */
DATA Base_projet_final;
SET Base_projet_final;
/* LTV_time_class */
IF LTV_time_class IN ("0 - 74", "74 - 85") THEN LTV_time_class_group = "0 - 85";
ELSE LTV_time_class_group = "85+";
/* orig_time_class */
IF orig_time_class IN ("-40 - 18", "19 - 23") THEN orig_time_class_group = "-40 - 23";
ELSE orig_time_class_group = "24 - 60";
/* hpi_time_class */
IF hpi_time_class IN ("159 - 180", "107 - 159") THEN hpi_time_class_group = "107 -
180";
ELSE IF hpi_time_class IN ("180 - 209", "209 - 220") THEN hpi_time_class_group = "180
- 200";
ELSE hpi_time_class_group = "220+";
/* uer_time_class */
IF uer_time_class IN ("3.8 - 4.7", "5 - 5.8") THEN uer_time_class_group = "<= 5.8";
ELSE uer_time_class_group = "5.9+";
/* FICO_orig_time_class */
IF FICO_orig_time_class IN ("400 - 629", "630 - 693") THEN
FICO_orig_time_class_group = "< 694";
ELSE FICO_orig_time_class_group = "694+";
RUN;
PROC FREQ DATA=Base_projet_final;
TABLES FICO_orig_time_class_group uer_time_class_group hpi_time_class_group
LTV_time_class_group orig_time_class_group;
RUN;
PROC LOGISTIC DATA=Base_projet_final PLOTS(ONLY)=ROC;
CLASS LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time / PARAM=REF;
MODEL default_time (EVENT='1') =
LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time;
/* Génération des prédictions */
OUTPUT OUT=pred_logit_class P=pred;
RUN;
PROC LOGISTIC DATA=Base_projet_final PLOTS(ONLY)=ROC;
CLASS LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time / PARAM=REF;
MODEL default_time (EVENT='1') =
LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time;
/* Génération des prédictions */
OUTPUT OUT=pred_logit_class P=pred;
RUN;
/* Création de la variable de classe prédite */
DATA pred_logit_class;
SET pred_logit_class;
predicted_class = (pred >= 0.5); /* Seuil à 0.5 */
RUN;
/* Calcul de la matrice de confusion */
PROC FREQ DATA=pred_logit_class;
TABLES default_time * predicted_class / CHISQ;
RUN;
/* Calcul du taux de classification correcte */
DATA pred_logit_class;
SET pred_logit_class;
correct_class = (default_time = predicted_class);
RUN;
PROC MEANS DATA=pred_logit_class MEAN;
VAR correct_class;
RUN;
