uses MLABC;

begin
  var df := DataFrame.FromCsv('../data/it_salary_easy.csv');

  // Кодирование категориальных признаков.
  // OrdinalEncoder создаётся для одного столбца и применяется через FitTransform.
  var encGrade := new OrdinalEncoder('grade');
  df := encGrade.FitTransform(df);
  var encSpec := new OrdinalEncoder('specialization');
  df := encSpec.FitTransform(df);
  var encCity := new OrdinalEncoder('city');
  df := encCity.FitTransform(df);
  var encFormat := new OrdinalEncoder('work_format');
  df := encFormat.FitTransform(df);
  var encCompany := new OrdinalEncoder('company_segment');
  df := encCompany.FitTransform(df);
  var encEdu := new OrdinalEncoder('education');
  df := encEdu.FitTransform(df);

  // Формируем матрицу признаков
  var X := df.ToMatrix(['experience_years', 'grade', 'specialization', 'city',
                        'work_format', 'company_segment', 'education']);

  // Целевая переменная
  var y := df.ToMatrix(['salary_rub']).GetCol(0);

  // Разбиение на обучающую (80%) и тестовую (20%) выборки
  var (X_train, X_test, y_train, y_test) :=
    Validation.TrainTestSplit(X, y, testRatio := 0.2, seed := 42);

  // Масштабирование признаков
  var scaler := new StandardScaler();
  var X_train_scaled := scaler.FitTransform(X_train);
  var X_test_scaled := scaler.Transform(X_test);

  // Обучение модели KNN-регрессии
  var model := new KNNRegressor(5);
  model.Fit(X_train_scaled, y_train);

  // Предсказание
  var pred := model.Predict(X_test_scaled);

  // Оценка качества
  writeln('=== Результаты KNN-регрессии (K=5) ===');
  writelnFormat('R²:   {0:F4}', Metrics.R2(y_test, pred));
  writelnFormat('MAE:  {0:F0} руб.', Metrics.MAE(y_test, pred));
  writelnFormat('RMSE: {0:F0} руб.', Metrics.RMSE(y_test, pred));
end.
