/* correlation matrix of numerical variables */
proc corr data=base_projet_v2 pearson outp=corr_matrix;
var balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time balance_orig_time FICO_orig_time LTV_orig_time Interest_Rate_orig_time;
title "Correlation matrix of numerical variables";
run;

/* correlation between variables and default risk */
/* Spearman correlation with "default_time" */
proc corr data=base_projet_v2 spearman outp=correlation_status;
var default_time time orig_time first_time mat_time balance_time LTV_time
interest_rate_time hpi_time gdp_time uer_time balance_orig_time
FICO_orig_time LTV_orig_time Interest_Rate_orig_time hpi_orig_time;
title "Correlation between variables and loan status";
run;

/* correlation matrix with "default_time" */
proc corr data=base_projet_v2 outp=corr_result noprint;
var time orig_time first_time mat_time balance_time LTV_time
interest_rate_time hpi_time gdp_time uer_time balance_orig_time
FICO_orig_time LTV_orig_time Interest_Rate_orig_time hpi_orig_time;
with default_time;
run;

/* transforming the matrix into a heatmap */
data corr_ready;
set corr_result;
where _TYPE_="CORR";

/* selecting only the correlation coefficients */
/* renaming the root variable */
length variable $32;
variable=_NAME_;

/* deleting redundant columns */
drop _TYPE_ _NAME_;

/* creating a list of variables to be transformed */
array vars{*} time orig_time first_time mat_time balance_time LTV_time
interest_rate_time hpi_time gdp_time uer_time balance_orig_time
FICO_orig_time LTV_orig_time Interest_Rate_orig_time hpi_orig_time;

/* loop to format table */
do i=1 to dim(vars);
y_variable=vname(vars[i]);

/* name of the variable */
corr_value=vars[i];

/* value of correlation */
output;
end;
drop i;
run;

/* creating the heatmap */
proc sgplot data=corr_ready;
heatmapparm x=variable y=y_variable colorresponse=corr_value /
colormodel=twocolorramp;
title "Correlation between variables and the default risk";
run;
