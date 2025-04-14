/* analysis of outliers and its distribution */
proc univariate data=base_projet_v2;
var balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time;
histogram balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time / normal;
qqplot balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time;
run;

/* outliers deletion */
data base_projet_v2;
set base_projet_v2;
if mat_time > 186 then
delete;
if balance_time > 950000 then
delete;
if LTV_time > 135 then
delete;
if interest_rate_time > 12.25 then
delete;
if balance_orig_time > 995000 then
delete;
if interest_rate_orig_time > 11.7 then
delete;
if status_time=0 then
delete;
run;

/* check after deletion */
proc means data=base_projet_v2 min max mean median;
var mat_time balance_time LTV_time interest_rate_time balance_orig_time
interest_rate_orig_time;
title "Statistics after outliers deletion";
run;
