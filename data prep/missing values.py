# check for missing values
missing_values = df.isnull().sum()
print("Missing values per variable :")
print(missing_values)

# bar chart of missing values
plt.figure(figsize=(10, 5))
plt.bar(missing_summary["variable"], missing_summary["missing_count"], width=0.5)
plt.ylabel("Number of missing values")
plt.xlabel("Variables")
plt.title("Bar chart of missing values")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
