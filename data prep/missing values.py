# check for missing values
missing_values = df.isnull().sum()
print("Missing values per variable :")
print(missing_values)
