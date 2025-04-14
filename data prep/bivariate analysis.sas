/* bivariate analysis according to payment status (default or not) */

/* statistics by status */
proc means data=work.base_projet_v2 n mean median std min max ;
class status_time;
var time orig_time first_time mat_time balance_time LTV_time interest_rate_time hpi_time gdp_time uer_time balance_orig_time
FICO_orig_time LTV_orig_time Interest_Rate_orig_time hpi_orig_time;
title "Statistiques descriptives des variables en fonction du statut du prêt";
run;

/* visu graphiques du score FICO par statut de prêt */
PROC SGPLOT DATA=work.base_projet_v2;
HISTOGRAM fico_orig_time / GROUP=status_time TRANSPARENCY=0.5;
DENSITY fico_orig_time / GROUP=status_time TYPE=KERNEL;
XAXIS LABEL="Statut du prêt (status_time)";
YAXIS LABEL="Fréquence";
KEYLEGEND / TITLE="Statut du prêt";
TITLE "Histogramme du score FICO par statut du prêt";
RUN;
/* visu graphique score FICO pour statut 1 et 2 seulement */
PROC FORMAT;
VALUE status_fmt 1="Défaut" 2="Remboursé";
RUN;
PROC SGPLOT DATA=work.base_projet_v2;
FORMAT status_time status_fmt.;
/* Appliquer les labels */
WHERE status_time IN (1, 2);
/* exclure status_time = 0 */
HISTOGRAM fico_orig_time / GROUP=status_time TRANSPARENCY=0.5;
DENSITY fico_orig_time / GROUP=status_time TYPE=KERNEL;
XAXIS LABEL="Score FICO";
YAXIS LABEL="Fréquence";
KEYLEGEND / TITLE="Statut du Prêt";
TITLE "Histogramme du Score FICO par Statut du Prêt";
RUN;
/* défaut et prêt sur condominium */
PROC MEANS DATA=work.base_projet_v2 MEAN MAX MIN STD;
WHERE status_time=1 AND REtype_CO_orig_time=1;
VAR _NUMERIC_;
RUN;
/* défaut et prêt sur non condominium (autres) */
PROC MEANS DATA=work.base_projet_v2 MEAN MAX MIN STD;
WHERE status_time=1 AND REtype_CO_orig_time=0;
VAR _NUMERIC_;
RUN;
/* taux de chômage en fonction du temps */
PROC SURVEYSELECT DATA=base_projet_v2 OUT=sample_datachomage METHOD=SRS
SAMPRATE=0.05 SEED=123;
RUN;
PROC SGPLOT DATA=sample_datachomage;
SCATTER X=time Y=uer_time / TRANSPARENCY=0.5;
XAXIS LABEL="Temps (mois)" GRID;
YAXIS LABEL="Taux de chômage (%)" GRID;
TITLE "Échantillon aléatoire du taux de chômage en fonction du temps";
RUN;
/* taux de croissance PIB en fonction du temps */
PROC SURVEYSELECT DATA=base_projet_v2 OUT=sample_datapib METHOD=SRS
SAMPRATE=0.05 SEED=123;
RUN;
PROC SGPLOT DATA=sample_datapib;
SCATTER X=time Y=gdp_time / TRANSPARENCY=0.5;
XAXIS LABEL="Temps (mois)" GRID;
YAXIS LABEL="Taux de croissance du PIB (%)" GRID;
TITLE
"Échantillon aléatoire du taux de croissance du PIB en fonction du temps";
RUN;
/* indice de prix immobilier en fonction du temps */
PROC SURVEYSELECT DATA=base_projet_v2 OUT=sample_datahpi METHOD=SRS
SAMPRATE=0.05 SEED=123;
RUN;
PROC SGPLOT DATA=sample_datahpi;
SCATTER X=time Y=hpi_time / TRANSPARENCY=0.5;
XAXIS LABEL="Temps (mois)" GRID;
YAXIS LABEL="Indice de prix immobilier (base 100)" GRID;
TITLE "Échantillon aléatoire de l'indice de prix en fonction du temps";
RUN;
