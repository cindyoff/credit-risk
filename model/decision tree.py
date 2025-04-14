# import data
df = pd.read_csv("path")

# selection of variables to explain the target
class_vars = [
    'LTV_time_class', 'first_time_class', 'orig_time_class', 'mat_time_class', 
    'hpi_time_class', 'uer_time_class', 'gdp_time_class', 'FICO_orig_time_class', 'invest_origin_time'
]

# check all variables are in the dataset before selecting them 
class_vars = [var for var in class_vars if var in df.columns]

X = df[class_vars]  # explanatory variables
y = df['DEFAUT']    # target variable (default)

# categorical variables encoding
label_encoders = {}
for col in class_vars:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col].astype(str))  # transformation into numerical values
    label_encoders[col] = le

# training (80%) and test (20%) database
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# decision tree training
clf = DecisionTreeClassifier(max_depth=5, random_state=42)  # Limite la profondeur de l'arbre
clf.fit(X_train, y_train)

# prediction on the test portion
y_pred = clf.predict(X_test)
y_pred_proba = clf.predict_proba(X_test)[:, 1]  # probabilities for class 1 (default)

# model assessment
accuracy = accuracy_score(y_test, y_pred)
conf_matrix = confusion_matrix(y_test, y_pred)
report = classification_report(y_test, y_pred)

print(f"Model accuracy : {accuracy:.4f}")
print("\n Confusion matrix :")
print(conf_matrix)
print("\n Classification report :")
print(report)

# feature importance of variables
importances = pd.DataFrame({'Variable': X.columns, 'Importance': clf.feature_importances_})
importances = importances.sort_values(by='Importance', ascending=False)

plt.figure(figsize=(8, 4))
plt.barh(importances['Variable'], importances['Importance'], color='skyblue')
plt.xlabel('Importance')
plt.title("Importance of variables within the decision tree")
plt.show()

# decision tree visualisation
plt.figure(figsize=(15, 8))
plot_tree(clf, feature_names=X.columns, class_names=['Non-Défaut', 'Défaut'], filled=True, fontsize=8)
plt.title("Visualisation de l'arbre de décision")
plt.show()

# ROC curve and AUC coefficient
fpr, tpr, _ = roc_curve(y_test, y_pred_proba)
roc_auc = auc(fpr, tpr)

plt.figure(figsize=(8, 6))
plt.plot(fpr, tpr, color='blue', lw=2, label=f'ROC curve (AUC = {roc_auc:.2f})')
plt.plot([0, 1], [0, 1], color='gray', linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('Rate of false positives')
plt.ylabel('Rate of true positives')
plt.title('Decision tree curve')
plt.legend(loc='lower right')
plt.grid()
plt.show()
