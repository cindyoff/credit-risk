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

/* Visualisation of distributions via histograms */
proc sgplot data=base_projet_v2;
histogram balance_time;
density balance_time;
title "Distribution of balance_time";
run;

proc sgplot data=base_projet_v2;
histogram LTV_time;
density LTV_time;
title "Distribution of LTV_time";
run;

proc sgplot data=base_projet_v2;
histogram interest_rate_time;
density interest_rate_time;
title "Distribution of interest_rate_time";
run;

proc sgplot data=base_projet_v2;
histogram hpi_time;
density hpi_time;
title "Distribution of hpi_time";
run; 

proc sgplot data=base_projet_v2;
histogram gdp_time;
density gdp_time;
title "Distribution of gdp_time";
run;

proc sgplot data=base_projet_v2;
histogram uer_time;
density uer_time;
title "Distribution of uer_time";
run;
