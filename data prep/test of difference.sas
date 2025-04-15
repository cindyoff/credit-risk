/* Student test to compare the average of groups from "status_time" */
proc ttest data=base_projet_v2;
class status_time;
var balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time;
title "Student test : comparison of averages according to loan status";
run;
