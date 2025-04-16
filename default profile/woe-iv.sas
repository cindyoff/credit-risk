/* Regroupement des classes apres analyse des WoE */
DATA Base_projet_final;
SET Base_projet_final;
/* LTV_time_class */
IF LTV_time_class IN ("0 - 74", "74 - 85") THEN LTV_time_class_group = "0 - 85";
ELSE LTV_time_class_group = "85+";
/* orig_time_class */
IF orig_time_class IN ("-40 - 18", "19 - 23") THEN orig_time_class_group = "-40 - 23";
ELSE orig_time_class_group = "24 - 60";
/* hpi_time_class */
IF hpi_time_class IN ("159 - 180", "107 - 159") THEN hpi_time_class_group = "107 -
180";
ELSE IF hpi_time_class IN ("180 - 209", "209 - 220") THEN hpi_time_class_group = "180
- 200";
ELSE hpi_time_class_group = "220+";
/* uer_time_class */
IF uer_time_class IN ("3.8 - 4.7", "5 - 5.8") THEN uer_time_class_group = "<= 5.8";
ELSE uer_time_class_group = "5.9+";
/* FICO_orig_time_class */
IF FICO_orig_time_class IN ("400 - 629", "630 - 693") THEN
FICO_orig_time_class_group = "< 694";
ELSE FICO_orig_time_class_group = "694+";
RUN;
PROC FREQ DATA=Base_projet_final;
TABLES FICO_orig_time_class_group uer_time_class_group hpi_time_class_group
LTV_time_class_group orig_time_class_group;
RUN;
PROC LOGISTIC DATA=Base_projet_final PLOTS(ONLY)=ROC;
CLASS LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time / PARAM=REF;
MODEL default_time (EVENT='1') =
LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time;
/* Génération des prédictions */
OUTPUT OUT=pred_logit_class P=pred;
RUN;
PROC LOGISTIC DATA=Base_projet_final PLOTS(ONLY)=ROC;
CLASS LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time / PARAM=REF;
MODEL default_time (EVENT='1') =
LTV_time_class_group first_time_class orig_time_class_group
mat_time_class hpi_time_class_group
uer_time_class_group gdp_time_class FICO_orig_time_class_group
investor_orig_time;
/* Génération des prédictions */
OUTPUT OUT=pred_logit_class P=pred;
RUN;
/* Création de la variable de classe prédite */
DATA pred_logit_class;
SET pred_logit_class;
predicted_class = (pred >= 0.5); /* Seuil à 0.5 */
RUN;
/* Calcul de la matrice de confusion */
PROC FREQ DATA=pred_logit_class;
TABLES default_time * predicted_class / CHISQ;
RUN;
/* Calcul du taux de classification correcte */
DATA pred_logit_class;
SET pred_logit_class;
correct_class = (default_time = predicted_class);
RUN;
PROC MEANS DATA=pred_logit_class MEAN;
VAR correct_class;
RUN;
