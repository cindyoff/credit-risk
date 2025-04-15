/* boxplots of financial variables according to "status_time" */
proc sgplot data=base_projet_v2;
vbox LTV_time / category=status_time;
title "Distribution of Loan-to-Value ratio (LTV_time) depending on the loan status";
run;

proc sgplot data=base_projet_v2;
vbox fico_orig_time / category=status_time;
title "Distribution of credit score (fico_orig_time) according to loan status";
run;

proc sgplot data=base_projet_v2;
vbox interest_rate_time / category=status_time;
title "Distribution of interest rate (interest_rate_time) according to loan status";
run;

/* histograms of macroeconomic variables according to "status_time" */
proc sgplot data=base_projet_v2;
histogram gdp_time / group=status_time;
title "Distribution of GDP growth rate (gdp_time) according to loan status";
run;

proc sgplot data=base_projet_v2;
histogram uer_time / group=status_time;
title "Distribution of unemployment rate (uer_time) according to loan status";
run;

proc sgplot data=base_projet_v2;
histogram hpi_time / group=status_time;
title "Distribution of house price index (hpi_time) according to loan status";
run;
