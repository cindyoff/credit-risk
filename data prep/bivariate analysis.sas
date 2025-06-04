/* bivariate analysis according to payment status (default or not) */

/* statistics by status */
proc means data=work.base_projet_v2 n mean median std min max ;
class status_time;
var time orig_time first_time mat_time balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time balance_orig_time
FICO_orig_time LTV_orig_time Interest_Rate_orig_time hpi_orig_time;
title "Statistiques descriptives des variables en fonction du statut du prêt";
run;

/* chart to visualise FICO score according to loan status */
proc sgplot data=work.base_projet_v2;
histogram fico_orig_time / group=status_time transparency=0.5;
density fico_orig_time / group=status_time type=KERNEL;
xaxis label="Loan status (status_time)";
yaxis label="Frequency" ;
keylegend / title="Loan status";
title "Histogram of FICO score according to loan status";
run;

/* chart of FICO score for status 1 and 2 only */
proc format;
value status_fmt 1="Default" 2="Paid back";
run;

proc sgplot data=work.base_projet_v2;
format  status_time status_fmt.;

/* apply labels */
where status_time in (1, 2);

/* exclude status_time = 0 */
histogram fico_orig_time / group=status_time transparency=0.5;
density fico_orig_time / group=status_time type=KERNEL;
xaxis label ="FICO score";
yaxis label="Frequency";
keylegend / title="Loan status";
title "Histogram of FICO score according to loan status";
run;

/* default and loan on condominium */
proc means data=work.base_projet_v2 mean max min std ;
where status_time=1 and REtype_CO_orig_time=1;
var _NUMERIC_;
run;

/* default and loan on non-condominium (others) */
proc means data=work.base_projet_v2 mean max min std ;
where status_time=1 and REtype_CO_orig_time=0;
var _NUMERIC_;
run;

/* unemployment rate depending on time */
proc surveyselect data=base_projet_v2 out=sample_datachomage method=SRS
samprate=0.05 seed=123;
run;

proc sgplot data=sample_datachomage;
scatter X=time Y=uer_time / transparency=0.5;
xaxis label="Time (months)" grid;
yaxis label="Unemployment rate (%)" grid;
title "Random sample of the unemployment rate depending on time";
run;

/* GDP growth rate and time */
proc surveyselect data=base_projet_v2 out=sample_datapib method=SRS
samprate=0.05 seed=123;
run;

proc sgplot data=sample_datapib;
scatter X=time Y=gdp_time / transparency=0.5;
xaxis label="Time (months)" grid;
yaxis label="GDP growth rate (%)" grid;
title "Random sample of the GDP growth rate depending on time";
run;

/* house price index and time */
proc surveyselect data=base_projet_v2 out=sample_datahpi method=SRS
samprate=0.05 seed=123;
run;

proc sgplot data=sample_datahpi;
scatter X=time Y=hpi_time / transparency=0.5;
xaxis label="Time (months)" grid;
yaxis label="House price index (100 basis)" grid;
title "Random sample of house price index depending on time";
run;
