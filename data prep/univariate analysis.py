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

# graphical analysis - numerical variables
# specifying the numerical variables
variables_to_plot = ["balance_time", "LTV_time", "interest_rate_time", "hpi_time", "gdp_time", "uer_time"]

