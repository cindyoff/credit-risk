# creating a dataframe with all the results
df_results = X_test.copy()
df_results['PD'] = y_pred_proba

# checking necessary variables for EAD (exposition at default) 
if 'balance_time' in df.columns and 'unused_limit' in df.columns:
    df_results['EAD'] = df.loc[df_results.index, 'balance_time'].fillna(0) + df.loc[df_results.index, 'unused_limit'].fillna(0)
elif 'balance_time' in df.columns:
    df_results['EAD'] = df.loc[df_results.index, 'balance_time'].fillna(0)
else:
    df_results['EAD'] = 1  # default value if data is absent

# LGD (loss given default) : hypothesis of a recovery rate of 55%
# therefore, LGD = 1 - 0.55 = 0.45
df_results['LGD'] = 1 - 0.55 

# EL (expected loss) - formula : EL = PD × LGD × EAD
df_results['EL'] = df_results['PD'] * df_results['LGD'] * df_results['EAD']

# default probability deciles
deciles = np.percentile(df_results['PD'], np.arange(0, 101, 10))

# creating a dataframe to display the deciles 
df_deciles = pd.DataFrame({'Décile': np.arange(0, 101, 10), 'Valeur de PD': deciles})

print("\nDéciles de la Probabilité de Défaut (PD) :")
print(df_deciles)

# boxplot to visualise the deciles
plt.figure(figsize=(8, 6))
sns.boxplot(x=df_results['PD'], color='lightblue')
for decile in deciles:
    plt.axvline(decile, color='red', linestyle='--', alpha=0.7)

plt.xlabel("Probabilité de Défaut (PD)")
plt.title("Distribution des PD avec Visualisation des Déciles")
plt.grid()
plt.show()

# defining risk categories according to the probability of default (PD)
def classify_risk(pd_value):
    if pd_value < 0.15:
        return "Small risk"
    elif pd_value < 0.50:
        return "Moderate risk"
    else:
        return "High risk"

df_results['Risque_Credit'] = df_results['PD'].apply(classify_risk)

# graphical distribution of PD
plt.figure(figsize=(8, 6))
sns.histplot(df_results['PD'], bins=50, kde=True, color='blue', edgecolor='black')
plt.axvline(0.15, color='green', linestyle='--', label="Seuil Faible/Moyen")
plt.axvline(0.5, color='orange', linestyle='--', label="Seuil Moyen/Élevé")
plt.xlabel("Probabilité de Défaut (PD)")
plt.ylabel("Nombre d'emprunteurs")
plt.title("Distribution des Probabilités de Défaut avec Seuils de Classification")
plt.legend()
plt.grid()
plt.show()

# descriptive statistics of PD per risk categories
df_results['Risque_Credit'] = df_results['PD'].apply(classify_risk)

# calculating the number of borrower per risk categories
risk_counts = df_results['Risque_Credit'].value_counts().sort_index()

print("\nDistribution of borrowers per risk categories :")
print(risk_counts)
print("\nProportion of risk categories (%) :")
print((risk_counts / risk_counts.sum()) * 100)

# visualisation : proportion of risk categories 
plt.figure(figsize=(8, 6))
sns.barplot(x=risk_counts.index, y=risk_counts.values, palette=['green', 'orange', 'red'])
plt.xlabel("Risk categories")
plt.ylabel("Number of borrowers")
plt.title("Proportion of borrowers accoring to their level of risk")
plt.grid(axis='y')
plt.show()









# Comparaison des statistiques des PD pour chaque classe de risque
risk_stats = df_results.groupby('Risque_Credit')['PD'].describe()
print("\nStatistiques des PD par classe de risque :")
print(risk_stats)

# Boxplot pour visualiser la dispersion des PD dans chaque classe de risque
plt.figure(figsize=(8, 6))
sns.boxplot(x=df_results['Risque_Credit'], y=df_results['PD'], palette=['green', 'orange', 'red'])
plt.xlabel("Catégorie de Risque")
plt.ylabel("Probabilité de Défaut (PD)")
plt.title("Dispersion des PD par Classe de Risque")
plt.grid()
plt.show()

# Calcul du Capital Économique (CE) basé sur la VaR ajustée au risque (quantile 99.9%)
z_score_99_9 = 3.09  # Valeur du quantile à 99.9%
# VaR à 99.9%
df_results['CE'] = z_score_99_9 * (df_results['PD'] * (1 - df_results['PD']))**0.5 * df_results['LGD'] * df_results['EAD']

# Calcul du RAROC (Risk-Adjusted Return on Capital)
# Hypothèse : Revenu net du prêt = 5% du EAD
df_results['Income'] = 0.05 * df_results['EAD']
df_results['RAROC'] = df_results['Income'] / df_results['CE']

# Calcul des Actifs Pondérés par le Risque (RWA) selon Bâle II/III
alpha = 1.06  # Facteur de correction de Bâle
df_results['RWA'] = alpha * df_results['EAD'] * df_results['PD'] * (1 - df_results['PD'])**0.5

# Calcul du Capital Requis en appliquant un ratio de fonds propres de 8% (Bâle II/III)
df_results['Capital_Requis'] = 0.08 * df_results['RWA']

# Affichage des résultats sous forme de tableau avec pandas
print("\nAperçu des 10 premières lignes des résultats :")
print(df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'Risque_Credit', 'RWA', 'Capital_Requis']].head(10))

# Affichage des statistiques principales
print("\nStatistiques des métriques de risque de crédit :")
print(df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'RWA', 'Capital_Requis']].describe())

# Histogramme des classes de risque
plt.figure(figsize=(8, 6))
df_results['Risque_Credit'].value_counts().plot(kind='bar', color=['green', 'orange', 'red'])
plt.xlabel("Catégorie de Risque")
plt.ylabel("Nombre d'emprunteurs")
plt.title("Distribution des Classes de Risque")
plt.grid(axis='y')
plt.show()

# Histogramme de la distribution des pertes attendues (EL)
plt.figure(figsize=(8, 6))
plt.hist(df_results['EL'], bins=30, color='red', alpha=0.7, edgecolor='black')
plt.xlabel("Perte Attendue (Expected Loss)")
plt.ylabel("Nombre d'emprunteurs")
plt.title("Distribution des Pertes Attendues")
plt.grid()
plt.show()

# Histogramme de la distribution du Capital Requis
plt.figure(figsize=(8, 6))
plt.hist(df_results['Capital_Requis'], bins=30, color='blue', alpha=0.7, edgecolor='black')
plt.xlabel("Capital Requis ($)")
plt.ylabel("Nombre d'emprunteurs")
plt.title("Distribution du Capital Requis (Bâle III)")
plt.grid()
plt.show()








# descriptive statistics of the metrics created 
# no scientific notation 
pd.set_option('display.float_format', '{:.6f}'.format)

# descriptive statistics for each financial metrics
stats = df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'RWA', 'Capital_Requis']].describe()
sum = df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'RWA', 'Capital_Requis']].sum()

print("\nStatistiques Descriptives des Métriques Financières :")
print(stats)
print(sum)
