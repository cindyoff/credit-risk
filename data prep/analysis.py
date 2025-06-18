# distribution of "balance_time"
plt.figure(figsize=(8, 5))
sns.histplot(df["balance_time"].dropna(), kde=True)
plt.title("Distribution of balance_time")
plt.xlabel("balance_time")
plt.ylabel("Number of observations")
plt.show()

# distribution of "LTV_time"
plt.figure(figsize=(8, 5))
sns.histplot(df["LTV_time"].dropna(), kde=True)
plt.title("Distribution of LTV_time")
plt.xlabel("LTV_time")
plt.ylabel("Number of observations")
plt.show()

# calculating the median value of "LTV_time"
med_LTV_time = df["LTV_time"].median()
df["LTV_time"] = df["LTV_time"].fillna(med_LTV_time) # replacing the missing values by its median value
df["LTV_time"].isnull().sum() # check

# descriptive statistics - numerical variables
columns_to_describe = [
    "time", "orig_time", "first_time", "mat_time", "balance_time", "LTV_time",
    "interest_rate_time", "hpi_time", "gdp_time", "uer_time", "balance_orig_time",
    "FICO_orig_time", "LTV_orig_time", "Interest_Rate_orig_time", "hpi_orig_time"
]
stats_summary = df[columns_to_describe].describe(percentiles=[0.5]).T[
    ["min", "max", "mean", "50%"]
].rename(columns={"50%": "median"})
print("Statistiques après outliers :")
print(stats_summary)
# detailed stats
detailed_stats = df[columns_to_describe].describe(
    percentiles=[0.01, 0.5, 0.99]
).T.rename(columns={"50%": "median", "std": "std_dev"})
print(detailed_stats[["count", "mean", "median", "std_dev", "min", "1%", "99%", "max"]])

# descriptive statistics - categorical variables
categorical_vars = [
    "payoff_time", "status_time", "REtype_CO_orig_time",
    "REtype_PU_orig_time", "REtype_SF_orig_time", "investor_orig_time"
]
print("Proportions des variables catégorielles :")
for var in categorical_vars:
    print(f"\n{var} :")
    print(df[var].value_counts(dropna=False))

# histograms
variables_to_plot = [
    "balance_time", "LTV_time", "interest_rate_time",
    "hpi_time", "gdp_time", "uer_time"
]

for var in variables_to_plot:
    plt.figure(figsize=(8, 5))
    sns.histplot(df[var].dropna(), kde=True, stat="density", bins=30)
    plt.title(f"Histogramme de {var}")
    plt.xlabel(var)
    plt.ylabel("Densité")
    plt.tight_layout()
    plt.show()

# specifying numerical variables
variables = [
    "time", "orig_time", "first_time", "mat_time", "balance_time", "LTV_time",
    "interest_rate_time", "hpi_time", "gdp_time", "uer_time", "balance_orig_time",
    "FICO_orig_time", "LTV_orig_time", "Interest_Rate_orig_time", "hpi_orig_time"
]
# descriptive statistics per "status_time"
grouped_stats = df.groupby("status_time")[variables].agg(["count", "mean", "median", "std", "min", "max"])
print("Statistiques descriptives des variables en fonction du statut du prêt :")
print(grouped_stats)

# histogram - FICO score per "status_time"
plt.figure(figsize=(10, 6))
sns.histplot(
    data=df,
    x="FICO_orig_time",
    hue="status_time",
    kde=True,
    stat="density",
    element="step",
    common_norm=False,
    alpha=0.5
)
plt.xlabel("FICO score")
plt.ylabel("Frequency")
plt.title("Histogram of the FICO score according to the loan status")
plt.legend(title="Loan status")
plt.show()
# filtering status == 1 et 2
df_fico_filtered = df[df["status_time"].isin([1, 2])]
# labels
status_fmt = {1: "Default", 2: "Paid back"}
df_fico_filtered["status_label"] = df_fico_filtered["status_time"].map(status_fmt)
plt.figure(figsize=(10, 6))
sns.histplot(
    data=df_fico_filtered,
    x="FICO_orig_time",
    hue="status_label",
    kde=True,
    stat="density",
    element="step",
    common_norm=False,
    alpha=0.5
)
plt.xlabel("FICO score")
plt.ylabel("Frequency")
plt.title("Histogram of the FICO score according to the loan status")
plt.legend(title = "Loan status")
plt.show()

# creating a dataset according to the type of real estate
df_defaut_condo = df[
    (df["status_time"] == 1) & (df["REtype_CO_orig_time"] == 1)
]

# descriptive statistics - default according to condominium
stats_defaut_condo = df_defaut_condo.select_dtypes(include='number').agg(["mean", "max", "min", "std"]).T
print("Statistics on defaulted loans on condominiums :")
print(stats_defaut_condo)

# descriptive statistics - default according to non-condominium
df_defaut_non_condo = df[
    (df["status_time"] == 1) & (df["REtype_CO_orig_time"] == 0)
]
stats_defaut_non_condo = df_defaut_non_condo.select_dtypes(include='number').agg(["mean", "max", "min", "std"]).T
print("Statistics on defaulted loans on non-condominium :")
print(stats_defaut_non_condo)

# graphical analysis - unemployment
# random sampling : 5%
sample_data = df.sample(frac=0.05, random_state=123)
# scatterplot - unemployment rate according to time
plt.figure(figsize=(10, 5))
plt.scatter(sample_data["time"], sample_data["uer_time"], alpha=0.5)
plt.title("Random sample of unemployment rate according to time")
plt.xlabel("Time (months)")
plt.ylabel("Unemployment rate (%)")
plt.grid(True)
plt.tight_layout()
plt.show()

# graphical analysis - GDP
# random sampling : 5%
sample_datagdp = df.sample(frac=0.05, random_state=123)
# scatterplot - gdp according to time
plt.figure(figsize=(10, 5))
plt.scatter(sample_datagdp["time"], sample_datagdp["gdp_time"], alpha=0.5)
plt.title("Random sample of GDP growth rate according to time")
plt.xlabel("Time (months)")
plt.ylabel("GDP growth rate (%)")
plt.grid(True)
plt.tight_layout()
plt.show()

# graphical analysis - hpi
# random sample : 5%
sample_datahpi = df.sample(frac=0.05, random_state=123)
# scatterplot - hpi of real estate prices des prix immobiliers en fonction du temps
plt.figure(figsize=(10, 5))
plt.scatter(sample_datahpi["time"], sample_datahpi["hpi_time"], alpha=0.5)
plt.title("Random sample of house price index according to time")
plt.xlabel("Time (months)")
plt.ylabel("House price index (base year)")
plt.grid(True)
plt.tight_layout()
plt.show()

# categorical variables crosssed with "status_time"
categorical_vars = [
    "REtype_CO_orig_time", "REtype_PU_orig_time",
    "REtype_SF_orig_time", "investor_orig_time"
]

# chi square test on each variable
for var in categorical_vars:
    contingency_table = pd.crosstab(df["status_time"], df[var])
    chi2, p, dof, expected = chi2_contingency(contingency_table)
    print(f"\nLink between status_time and {var}")
    print("Contingency table :\n", contingency_table)
    print(f"Chi² = {chi2:.2f}, p-value = {p:.4f}, ddl = {dof}")
    print("Significant at 5%" if p < 0.05 else "Not significant")

# boxplot of financial variables according to "status_time"
variables_boxplot = ["LTV_time", "FICO_orig_time", "interest_rate_time"]

# for var in variables_boxplot:
    plt.figure(figsize=(8, 5))
    sns.boxplot(x="status_time", y=var, data= df)
    plt.title(f"Proportion of {var} according to the loan status")
    plt.xlabel("Loan status (status_time)")
    plt.ylabel(var)
    plt.tight_layout()
    plt.show()

# grouped histogram of macroeconomic variables according to "status_time"
variables_histogram = ["gdp_time", "uer_time", "hpi_time"]

for var in variables_histogram:
    plt.figure(figsize=(8, 5))
    sns.histplot(
        data= df,
        x=var,
        hue="status_time",
        element="step",
        common_norm=False,
        stat="density",
        kde=True,
        alpha=0.5
    )
    plt.title(f"Distribution of {var} according to the loan status")
    plt.xlabel(var)
    plt.ylabel("Density")
    plt.tight_layout()
    plt.show()

# t-test - Student test
ttest_vars = ["balance_time", "LTV_time", "interest_rate_time", "hpi_time", "gdp_time", "uer_time"]

# groupes : default (1) vs paid back (2)
group1 = df[df["status_time"] == 1]
group2 = df[df["status_time"] == 2]
print("Student test : comparing means according to status_time")
for var in ttest_vars:
    stat, p_value = ttest_ind(group1[var].dropna(), group2[var].dropna(), equal_var=False)
    print(f"{var}: t = {stat:.3f}, p-value = {p_value:.4f} → {'significant at 5%' if p_value < 0.05 else 'not significant'}")

# correlation matrix
vars_corr = [
    "balance_time", "LTV_time", "interest_rate_time", "hpi_time", "gdp_time",
    "uer_time", "balance_orig_time", "FICO_orig_time", "LTV_orig_time", "Interest_Rate_orig_time"
]
# Pearson
corr_matrix_pearson = df[vars_corr].corr(method="pearson")
print("Pearson correlation matrix :")
print(corr_matrix_pearson)
# Spearman
vars_corr_spearman = [
    "default_time", "time", "orig_time", "first_time", "mat_time", "balance_time", "LTV_time",
    "interest_rate_time", "hpi_time", "gdp_time", "uer_time", "balance_orig_time",
    "FICO_orig_time", "LTV_orig_time", "Interest_Rate_orig_time", "hpi_orig_time"
]
corr_matrix_spearman = df[vars_corr_spearman].corr(method="spearman")
print(corr_matrix_spearman)
spearman_with_default = corr_matrix_spearman["default_time"].drop("default_time")
print("\nSpearman correlation with default_time :")
print(spearman_with_default.sort_values(ascending=False))

# heatmap avec default_time
plt.figure(figsize=(10, 6))
sns.heatmap(
    spearman_with_default.to_frame().T,
    annot=True,
    cmap="coolwarm",
    center=0,
    cbar_kws={"label": "Correlation with default_time"}
)
plt.title("Spearman correlation with default_time")
plt.yticks([])
plt.tight_layout()
plt.show()
