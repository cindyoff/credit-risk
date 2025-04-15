/* Frequency of real estate goods and loan status */
proc freq data=base_projet_v2;
tables status_time*(REtype_CO_orig_time REtype_PU_orig_time REtype_SF_orig_time investor_orig_time) / chisq ;
title "Link between loan status and categotical variables (Chi² test)";
run;
