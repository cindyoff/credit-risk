data base_projet_v2;
set base_projet_v2;

/* Step 1 : LTV_time median value */
proc means data=base_projet_v2 median noprint;
var LTV_time;
output out=med_LTV median=med_LTV_time;
RUN;

/* Step 2 : imputation */
data base_projet_v2;
set base_projet_v2;
if _N_=1 then set med_LTV;

/* replace missing values of LTV_time with its median value */
if missing(LTV_time) then LTV_time=med_LTV_time;
run;

/* Step 3 : check after imputation */
proc means data=base_projet_v2 nmiss;
var LTV_time;
run;
