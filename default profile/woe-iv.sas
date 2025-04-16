/* selecting relevant variables for the study */
%macro WOE_IV(var);

/* step 1 : creating a table with the groups and count of defaults */
proc sql;
create table WOE_&var. as
select
&var. as Groupes,
count(*) as Total,
sum(case when DEFAUT = 0 then 1 else 0 end) as Non_Defauts,
sum(case when DEFAUT = 1 then 1 else 0 end) as Defauts
from Base_projet_final
group by &var.;
quit;

/* step 2 : calculating the sum of default and non-default */
proc sql;
select sum(Defauts), sum(Non_Defauts)
into :Total_Defaut, :Total_Non_Defaut
from WOE_&var.;
quit;

/* step 3 : calculating WoE (weight of evidence) and IV (infomation value) */
data WOE_&var.;
set WOE_&var. end=last;
retain Total_sum;

/* global sum at once */
if _n_ = 1 then Total_sum = sum(Total);

/* calculating distributions */
Share = Total / Total_sum;
Taux_Defauts = Defauts / Total;
Dist_Non_Defaut = Non_Defauts / &Total_Non_Defaut;
Dist_Defaut = Defauts / &Total_Defaut;

/* avoiding log(0) */
if Dist_Non_Defaut = 0 then Dist_Non_Defaut = 0.0001;
if Dist_Defaut = 0 then Dist_Defaut = 0.0001;

/* WoE and IV */
WoE = log(Dist_Non_Defaut / Dist_Defaut);
IV = (Dist_Non_Defaut - Dist_Defaut) * WoE;
run;

/* step 4 : storing IV */
proc sql;
create table IV_&var. as
select "&var." as Variable, sum(IV) as IV
from WOE_&var.;
quit;
%mend;

%WOE_IV(FICO_orig_time_class);
%WOE_IV(LTV_time_class);
%WOE_IV(LTV_orig_time_class);
%WOE_IV(balance_orig_time_class);
%WOE_IV(balance_time_class);
%WOE_IV(first_time_class);
%WOE_IV(gdp_time_class);
%WOE_IV(hpi_time_class);
%WOE_IV(interest_rate_time_class);
%WOE_IV(mat_time_class);
%WOE_IV(orig_time_class);
%WOE_IV(uer_time_class);
%WOE_IV(hpi_orig_time_class);
%WOE_IV(interest_rate_orig_time_class);
