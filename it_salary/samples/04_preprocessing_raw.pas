uses MLABC;

begin
  var df := DataFrame.FromCsv('../data/it_salary_raw.csv');

  writeln('=== Исходные данные (raw) ===');
  writelnFormat('Размерность: {0} строк, {1} столбцов', df.RowCount, df.ColumnCount);
  writeln;

  // 1. Удаление текстового столбца description и столбца даты:
  //    для базовой модели они не используются
  df := df.Drop(['description', 'posted_date']);

  // 2. Вывод числа пропусков по всем столбцам
  writeln('=== Пропуски до обработки ===');
  df.MissingCounts.Print;
  writeln;

  // 3. Заполнение пропусков
  //    Числовой признак — медианой
  var impExp := new Imputer(ImputeStrategy.isMedian, ['experience_years']);
  df := impExp.FitTransform(df);
  //    Категориальные признаки — константой 'unknown'
  var impFormat := new Imputer('unknown', ['work_format']);
  df := impFormat.FitTransform(df);
  var impCompany := new Imputer('unknown', ['company_segment']);
  df := impCompany.FitTransform(df);
  var impEdu := new Imputer('unknown', ['education']);
  df := impEdu.FitTransform(df);

  writeln('=== Пропуски после обработки ===');
  df.MissingCounts.Print;
  writeln;

  // 4. Удаление выбросов по salary_rub (Z-score метод)
  //    Вычисляем среднее и стандартное отклонение
  var salMean := df.Mean('salary_rub');
  var salStd := df.Std('salary_rub');
  //    Оставляем строки, где |Z| < 3 (в пределах 3 стандартных отклонений)
  df := df.Filter(r -> Abs(r['salary_rub'].ToFloat - salMean) <= 3 * salStd);

  writelnFormat('После удаления выбросов (Z-score < 3): {0} строк', df.RowCount);
  writeln;

  // 5. Кодирование категориальных признаков
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

  // 6. Построение модели
  var X := df.ToMatrix(['experience_years', 'grade', 'specialization', 'city',
                        'work_format', 'company_segment', 'education']);
  var y := df.ToMatrix(['salary_rub']).GetCol(0);

  var (X_train, X_test, y_train, y_test) :=
    Validation.TrainTestSplit(X, y, testRatio := 0.2, seed := 42);

  var scaler := new StandardScaler();
  var X_train_scaled := scaler.FitTransform(X_train);
  var X_test_scaled := scaler.Transform(X_test);

  var model := new KNNRegressor(5);
  model.Fit(X_train_scaled, y_train);
  var pred := model.Predict(X_test_scaled);

  writeln('=== Результаты после предобработки raw-версии ===');
  writelnFormat('R²:   {0:F4}', Metrics.R2(y_test, pred));
  writelnFormat('MAE:  {0:F0} руб.', Metrics.MAE(y_test, pred));
  writelnFormat('RMSE: {0:F0} руб.', Metrics.RMSE(y_test, pred));
end.
