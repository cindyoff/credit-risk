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
df_deciles = pd.DataFrame({'Decile': np.arange(0, 101, 10), 'Value of PD': deciles})

print("\nDeciles of PD :")
print(df_deciles)

# boxplot to visualise the deciles
plt.figure(figsize=(8, 6))
sns.boxplot(x=df_results['PD'], color='lightblue')
for decile in deciles:
    plt.axvline(decile, color='red', linestyle='--', alpha=0.7)

plt.xlabel("Probability of default (PD)")
plt.title("Distribution of PD according to deciles")
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
plt.axvline(0.15, color='green', linestyle='--', label="Small/moderate threshold")
plt.axvline(0.5, color='orange', linestyle='--', label="Moderate/high threshold")
plt.xlabel("Probability of default (PD)")
plt.ylabel("Number of borrowers")
plt.title("Distribution of probability of defaults with classification thresholds")
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

# comparing statistics between each PD risk category
risk_stats = df_results.groupby('Risque_Credit')['PD'].describe()
print("\nStatistics of PD per risk category :")
print(risk_stats)

# boxplot to visualise the scattering in each risk category
plt.figure(figsize=(8, 6))
sns.boxplot(x=df_results['Risque_Credit'], y=df_results['PD'], palette=['green', 'orange', 'red'])
plt.xlabel("Risk category")
plt.ylabel("Probability of default (PD)")
plt.title("Scattering of PD per risk category")
plt.grid()
plt.show()

# calculating EC (economic capital) based on the adjusted 99.9% VaR (value at risk)
z_score_99_9 = 3.09  # 99.9% 
df_results['CE'] = z_score_99_9 * (df_results['PD'] * (1 - df_results['PD']))**0.5 * df_results['LGD'] * df_results['EAD']

# calculating RAROC (risk-adjusted return on capital)
# hypothesis : net revenue of the loan = 5% of EAD
df_results['Income'] = 0.05 * df_results['EAD']
df_results['RAROC'] = df_results['Income'] / df_results['CE']

# calculating RWA (risk-weighted assets) according to Basel II/III
alpha = 1.06  # conversion factor from Basel framework
df_results['RWA'] = alpha * df_results['EAD'] * df_results['PD'] * (1 - df_results['PD'])**0.5

# calculating CR (capital requirement) with a ratio of 8% equity (Basel II/III)
df_results['Capital_Requis'] = 0.08 * df_results['RWA']

print("\nPreview of the first 10 lines of results :")
print(df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'Risque_Credit', 'RWA', 'Capital_Requis']].head(10))

# main statistics 
print("\nMetrics of credit risk :")
print(df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'RWA', 'Capital_Requis']].describe())

# histogram of risk categories
plt.figure(figsize=(8, 6))
df_results['Risque_Credit'].value_counts().plot(kind='bar', color=['green', 'orange', 'red'])
plt.xlabel("Risk category")
plt.ylabel("Number of borrowers")
plt.title("Distribution of risk category")
plt.grid(axis='y')
plt.show()

# histogram of EL (expected loss)
plt.figure(figsize=(8, 6))
plt.hist(df_results['EL'], bins=30, color='red', alpha=0.7, edgecolor='black')
plt.xlabel("EL")
plt.ylabel("Number of borrowers")
plt.title("Expected loss distribution")
plt.grid()
plt.show()

# histogram of CR (capital requirement)
plt.figure(figsize=(8, 6))
plt.hist(df_results['Capital_Requis'], bins=30, color='blue', alpha=0.7, edgecolor='black')
plt.xlabel("Capital requirement ($)")
plt.ylabel("Number of borrowers")
plt.title("Distribution of CR")
plt.grid()
plt.show()

# descriptive statistics of the metrics created 
pd.set_option('display.float_format', '{:.6f}'.format) # no scientific notation 

# descriptive statistics for each financial metrics
stats = df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'RWA', 'Capital_Requis']].describe()
sum = df_results[['PD', 'EAD', 'LGD', 'EL', 'CE', 'RAROC', 'RWA', 'Capital_Requis']].sum()

print("\nDescriptive statistics of the financial metrics created :")
print(stats)
print(sum)
