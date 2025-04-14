/* categorical variables */
proc freq data=base_projet_v2;
tables payoff_time status_time REtype_CO_orig_time REtype_PU_orig_time REtype_SF_orig_time investor_orig_time;
title "Frequency of each categorical variable";
run;

/* numerical variables */
proc means data=base_projet_v2 n mean median std min max P1 P99;
var time orig_time first_time mat_time balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time balance_orig_time
FICO_orig_time LTV_orig_time Interest_Rate_orig_time hpi_orig_time;
title "Descriptive statistics of numerical variables";
run;

/* 3. Visualisation des distributions avec des histogrammes */
PROC SGPLOT DATA=base_projet_v2;
HISTOGRAM balance_time;
DENSITY balance_time;
TITLE "Distribution de balance_time";
RUN;
PROC SGPLOT DATA=base_projet_v2;
HISTOGRAM LTV_time;
DENSITY LTV_time;
TITLE "Distribution de LTV_time";
RUN;
PROC SGPLOT DATA=base_projet_v2;
HISTOGRAM interest_rate_time;
DENSITY interest_rate_time;
TITLE "Distribution de interest_rate_time";
RUN;
PROC SGPLOT DATA=base_projet_v2;
HISTOGRAM hpi_time;
DENSITY hpi_time;
TITLE "Distribution de hpi_time";
RUN;
PROC SGPLOT DATA=base_projet_v2;
HISTOGRAM gdp_time;
DENSITY gdp_time;
TITLE "Distribution de gdp_time";
RUN;
PROC SGPLOT DATA=base_projet_v2;
HISTOGRAM uer_time;
DENSITY uer_time;
TITLE "Distribution de uer_time";
RUN;
