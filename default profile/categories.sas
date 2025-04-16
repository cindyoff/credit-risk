/* categories for continuous variables */
%macro segment(var);
proc rank data=base_projet_v2 out=Base_projet3 groups=5;
var &var.;
ranks q&var.;
run;
proc freq data=Base_projet3;
tables q&var.*default_time / chisq out=chi_&var.;
run;
proc transpose data=chi_&var. out=chi_&var._1;
var count;
id default_time;
by q&var.;
run;
data chi_&var._1;
set chi_&var._1;
p1=_1/(_0 + _1); /* Proportion des défauts */
run;
proc gplot data=chi_&var._1;
plot p1 * q&var.;
run;
quit;
proc means data=Base_projet3;
var &var.;
class q&var.;
run;
%mend;

%segment(time);
%segment(first_time);
%segment(orig_time);
%segment(LTV_time);
%segment(mat_time);
%segment(hpi_time);
%segment(gdp_time);
%segment(uer_time);
%segment(FICO_orig_time);
%segment(interest_rate_time);
%segment(balance_time);
%segment(balance_orig_time);
%segment(LTV_orig_time);
%segment(interest_rate_orig_time);
%segment(hpi_orig_time);

/* building the final dataset with the categories */
data Base_projet_final;
set base_projet_v2;

/* time related variables */
if 1 <= first_time <= 21 then first_time_class = "1-21";
else if 22 <= first_time <= 26 then first_time_class = "22-26";
else if 27 <= first_time <= 60 then first_time_class = "27 - 60";
if -40 <= orig_time <= 18 then orig_time_class = "-40 - 18";
else if 19 <= orig_time <= 23 then orig_time_class = "19 - 23";
else if 24 <= orig_time <= 60 then orig_time_class = "24 - 60";

/* LTV_time */
if 0 <= LTV_time < 74 then LTV_time_class = "0 - 74";
else if 74 <= LTV_time < 85 then LTV_time_class = "74 - 85";
else if 85 <= LTV_time < 102 then LTV_time_class = "85 - 102";
else if LTV_time >= 102 then LTV_time_class = "102+";

/* mat_time */
if 23 <= mat_time <= 137 then mat_time_class = "23 - 137";
else if 138 <= mat_time <= 143 then mat_time_class = "138 - 143";
else if 144 <= mat_time <= 186 then mat_time_class = "144 - 186";

/* hpi_time */
if 107.83 <= hpi_time <= 159 then hpi_time_class = "107 - 159";
else if 159 < hpi_time <= 180 then hpi_time_class = "159 - 180";
else if 180 < hpi_time <= 209 then hpi_time_class = "180 - 209";
else if 209 < hpi_time <= 220 then hpi_time_class = "209 - 220";
else if hpi_time > 220 then hpi_time_class = "220+";

/* hpi_orig_time */
if 75.73 <= hpi_orig_time <= 186.91 then hpi_orig_time_class = "75.73 - 186.91";
else if 187.20 <= hpi_orig_time <= 219.67 then hpi_orig_time_class = "187.20 - 219.67";
else if 221.91 <= hpi_orig_time <= 226.29 then hpi_orig_time_class = "221.91 - 226.29";

/* gdp_time */
if -4.147 <= gdp_time <= 1.427 then gdp_time_class = "-4.147 - 1.427";
else if 1.507 <= gdp_time <= 2.44 then gdp_time_class = "1.507 - 2.44";
else if 2.24 <= gdp_time <= 5.13 then gdp_time_class = "2.24 - 5.13";

/* uer_time */
if 3.8 <= uer_time <= 4.7 then uer_time_class = "3.8 - 4.7";
else if 5 <= uer_time <= 5.8 then uer_time_class = "5 - 5.8";
else if 5.9 <= uer_time <= 10 then uer_time_class = "5.9 - 10";

/* FICO_orig_time */
if 400 <= FICO_orig_time <= 629 then FICO_orig_time_class = "400 - 629";
else if 630 <= FICO_orig_time <= 693 then FICO_orig_time_class = "630 - 693";
else if 694 <= FICO_orig_time <= 840 then FICO_orig_time_class = "694 - 840";

/* interest rate */
if 1 <= interest_rate_time <= 6.5 then interest_rate_time_class = "1 - 6.5";
else if 6.501 <= interest_rate_time <= 7.985 then interest_rate_time_class = "6.501 - 7.985";
else if 7.990 <= interest_rate_time <= 12.25 then interest_rate_time_class = "7.990 - 12.25";
if 0 <= interest_rate_orig_time <= 5.44 then interest_rate_orig_time_class = "0 - 5.44";
else if 5.45 <= interest_rate_orig_time <= 7.23 then interest_rate_orig_time_class = "5.45 - 7.23";
else if 7.235 <= interest_rate_orig_time <= 11.70 then interest_rate_orig_time_class = "7.235 - 11.70";

/* balance_time */
if 0 <= balance_time <= 136185.35 then balance_time_class = "0 - 136185.35";
else if 136187.59 <= balance_time <= 266287.23 then balance_time_class = "136187.59 - 266287.23";
else if 266310.80 <= balance_time <= 949366.59 then balance_time_class = "266310.80 - 949366.59";

/* balance_orig_time */
if 0 <= balance_orig_time <= 140700 then balance_orig_time_class = "0 - 140700";
else if 140720 <= balance_orig_time <= 272500 then balance_orig_time_class = "140720 - 272500";
else if 272700 <= balance_orig_time <= 995000 then balance_orig_time_class = "272700 - 995000";

/* LTV_orig_time */
if 50.10 <= LTV_orig_time <= 79.90 then LTV_orig_time_class = "50.10 - 79.90";
else if 80 <= LTV_orig_time <= 100 then LTV_orig_time_class = "80 - 100";

/* target variable */
if status_time = 1 then DEFAUT = 1;
else DEFAUT = 0;
run;

/* summary table for the categories created */
proc freq data=Base_projet_final;
tables LTV_time_class first_time_class orig_time_class mat_time_class hpi_time_class uer_time_class gdp_time_class investor_orig_time;
run;

/* establishing categories after WoE (weight of evidence) analysis */
data Base_projet_final;
set Base_projet_final;

/* LTV_time_class */
if LTV_time_class IN ("0 - 74", "74 - 85") then LTV_time_class_group = "0 - 85";
else LTV_time_class_group = "85+";

/* orig_time_class */
if orig_time_class IN ("-40 - 18", "19 - 23") then orig_time_class_group = "-40 - 23";
else orig_time_class_group = "24 - 60";

/* hpi_time_class */
if hpi_time_class IN ("159 - 180", "107 - 159") then hpi_time_class_group = "107 - 180";
else if hpi_time_class IN ("180 - 209", "209 - 220") then hpi_time_class_group = "180 - 200";
else hpi_time_class_group = "220+";

/* uer_time_class */
if uer_time_class IN ("3.8 - 4.7", "5 - 5.8") then uer_time_class_group = "<= 5.8";
else uer_time_class_group = "5.9+";

/* FICO_orig_time_class */
if FICO_orig_time_class in ("400 - 629", "630 - 693") then FICO_orig_time_class_group = "< 694";
ELSE FICO_orig_time_class_group = "694+";
run;

/* summary of categories */
proc freq data=Base_projet_final;
tables FICO_orig_time_class_group uer_time_class_group hpi_time_class_group LTV_time_class_group orig_time_class_group;
run;

/* Calcul du taux de classification correcte */
DATA pred_logit_class;
SET pred_logit_class;
correct_class = (default_time = predicted_class);
RUN;
PROC MEANS DATA=pred_logit_class MEAN;
VAR correct_class;
RUN;
