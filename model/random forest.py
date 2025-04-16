# import data
df = pd.read_csv("path") # df = initial mortgage dataset

# selecting relevant variables
class_vars = [
    'LTV_time_class', 'first_time_class', 'orig_time_class', 'mat_time_class', 
    'hpi_time_class', 'uer_time_class', 'gdp_time_class', 'FICO_orig_time_class', 'invest_origin_time'
]

# checking all variables exist in the dataset
class_vars = [var for var in class_vars if var in df.columns]

X = df[class_vars]  # explanatory variables
y = df['DEFAUT']    # target variable

# categorical variables encoding
label_encoders = {}
for col in class_vars:
    le = LabelEncoder()
    X[col] = le.fit_transform(X[col].astype(str))  # transformation into numerical values
    label_encoders[col] = le

# dividing between train (80%) and test (20%) datasets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# random forest
rf_clf = RandomForestClassifier(
    n_estimators=100,  # Nombre d'arbres
    max_depth=5,       # Profondeur maximale des arbres
    min_samples_leaf=50,  # Nombre minimum d'observations par feuille
    random_state=42
)
rf_clf.fit(X_train, y_train)

# predicting on the test dataset
y_pred = rf_clf.predict(X_test)
y_pred_proba = rf_clf.predict_proba(X_test)[:, 1]  # status 1 (default)

# model assessment
accuracy = accuracy_score(y_test, y_pred)
conf_matrix = confusion_matrix(y_test, y_pred)
report = classification_report(y_test, y_pred)

print(f"Random forest model accuracy : {accuracy:.4f}")
print("\nConfusion matrix :")
print(conf_matrix)
print("\nClassification report :")
print(report)

# variables feature importance
importances = pd.DataFrame({'Variable': X.columns, 'Importance': rf_clf.feature_importances_})
importances = importances.sort_values(by="Importance", ascending=False)

plt.figure(figsize=(8, 4))
plt.barh(importances['Variable'], importances['Importance'], color='skyblue')
plt.xlabel("Importance")
plt.title("Importance des variables dans le modèle Random Forest")
plt.show()

# ROC curve and AUC value
fpr, tpr, _ = roc_curve(y_test, y_pred_proba)
roc_auc = auc(fpr, tpr)

plt.figure(figsize=(8, 6))
plt.plot(fpr, tpr, color='blue', lw=2, label=f'ROC curve (AUC = {roc_auc:.2f})')
plt.plot([0, 1], [0, 1], color='gray', linestyle='--')  # Ligne de référence
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('Taux de faux positifs (FPR)')
plt.ylabel('Taux de vrais positifs (TPR)')
plt.title('Courbe ROC du modèle Random Forest')
plt.legend(loc='lower right')
plt.grid()
plt.show()
