/* import table */
%web_drop_table(WORK.IMPORT);
filename reffile 'path';
proc import datafile = reffile dbms = csv out = work.import;
getnames = yes;
run;

/* chek dataset content */
proc contents data=work.import;
run;

/* preview of the first lines */
proc print data=work.import(OBS=10);
RUN;

/* data sorting and deletion of duplicates */
PROC SORT DATA=WORK.IMPORT OUT=base_projet_v2;
BY id descending time;
RUN;
PROC SORT DATA=base_projet_v2 NODUPKEY;
BY id;
RUN;

/* checking missing values */
PROC MEANS DATA=base_projet_v2 NMISS;
RUN;

/* adding clear labels */
PROC FORMAT;
value payoe_fmt 0="Non paid back" 1="Paid back";
value status_fmt 1="Payment default" 2="Loan paid back";
value retype_co_fmt 0=“Non condominium” 1=“Condominium”;
value retype_pu_fmt 0="Non PUD (Planned Unit Development)"
1="PUD (Planned Unit Development)";
value retype_sf_fmt 0=“Not individual house” 1=“Individual house”;
value investor_fmt 0="House investor" 1=“Institutional investor”;
run;

/* formatting on variables */
data base_projet_v2;
set base_projet_v2;
format payoe_time payoe_fmt.
status_time status_fmt.
REtype_CO_orig_time retype_co_fmt.
REtype_PU_orig_time retype_pu_fmt.
REtype_SF_orig_time retype_sf_fmt.
investor_orig_time investor_fmt.;
run;

/* macro for a detailed summary of missing values */
%macro missing_summary(data=, vars=);
proc sql;
create table missing_summary as %let i = 1;
%let var = %scan(&vars, &i);
%do %while(&var ne);
%if &i=1 %then
select "&var" as variable, sum(missing(&var)) as
missing_count from &data;
%else
union all select "&var" as variable, sum(missing(&var)) as missing_count
from &data;
%let i = %eval(&i + 1);
%let var = %scan(&vars, &i);
%end;
quit;

/* histogram to visualise missing values */
proc sgplot data=missing_summary;
vbar variable / response=missing_count datalabel barwidth=0.5;
yaxis label="Number of missing values";
xaxis label="Variables" discreteorder=data;
title "Visualisation of missing values";
run;
%mend;

/* macro recall with all variables from the dataset base_projet_v2 */
%missing_summary(data=base_projet_v2, vars=mat_time balance_time LTV_time
interest_rate_time balance_orig_time interest_rate_orig_time);

/* charts to visualise the distribution before data manipulation */
proc sgplot data = base_projet_v2;
histogram balance_time / scale = count;
density balance_time;
title "Distribution of the balance left (before data manipulation)";
run;
proc sgplot data = base_projet_v2;
histogram LTV_time / scale = count;
density LTV_time;
title "Distribution of LTV ratio (before data manipulation)";
run;
