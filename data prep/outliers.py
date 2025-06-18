# histogram with normal distribution + QQplot
for var in variables_to_plot:
    plt.figure(figsize=(10, 4))
    
    # Histogramme avec densité normale
    sns.histplot(df[var], kde=True, stat='density', bins=30)
    mean, std = df[var].mean(), df[var].std()
    x = np.linspace(df[var].min(), df[var].max(), 100)
    plt.plot(x, stats.norm.pdf(x, mean, std), color='red', linestyle='--')
    plt.title(f"Distribution de {var} avec densité normale")
    plt.xlabel(var)
    plt.show()
    
    # QQ plot
    stats.probplot(df[var].dropna(), dist="norm", plot=plt)
    plt.title(f"QQPlot de {var}")
    plt.show()

# deleting outliers
df = df[
    (df["mat_time"] <= 186) &
    (df["balance_time"] <= 950000) &
    (df["LTV_time"] <= 135) &
    (df["interest_rate_time"] <= 12.25) &
    (df["balance_orig_time"] <= 995000) &
    (df["Interest_Rate_orig_time"] <= 11.7) &
    (df["status_time"] != 0)
]
