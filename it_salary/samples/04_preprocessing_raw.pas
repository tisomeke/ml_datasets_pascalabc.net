uses MLABC;

begin
  var df := DataFrame.FromCsv('../data/it_salary_raw.csv');

  writeln('=== Исходные данные (raw) ===');
  writelnFormat('Размерность: {0} строк, {1} столбцов', df.RowCount, df.ColumnCount);
  writeln;

  // 1. Удаляем description (текст), извлекаем месяц из posted_date
  df := df.Drop(['description']);
  df := df.WithColumnInt('posted_month', r ->
    begin
      var dt := r['posted_date'];
      if not dt.IsValid then Result := -1  // пропуск
      else Result := dt.ToDateTime.Month;
    end);
  df := df.Drop(['posted_date']);

  // 2. Пропуски до обработки
  writeln('=== Пропуски до обработки ===');
  df.MissingCounts.Print;
  writeln;

  // 3. Заполняем пропуски: числовые — медианой, категориальные — 'unknown'
  var impExp := new Imputer(ImputeStrategy.isMedian, ['experience_years']);
  df := impExp.FitTransform(df);
  var impFormat := new Imputer('unknown', ['work_format']);
  df := impFormat.FitTransform(df);
  var impCompany := new Imputer('unknown', ['company_segment']);
  df := impCompany.FitTransform(df);
  var impEdu := new Imputer('unknown', ['education']);
  df := impEdu.FitTransform(df);

  writeln('=== Пропуски после обработки ===');
  df.MissingCounts.Print;
  writeln;

  // 4. Удаляем выбросы по salary_rub (Z-score, порог 3σ)
  var salMean := df.Mean('salary_rub');
  var salStd := df.Std('salary_rub');
  df := df.Filter(r -> Abs(r['salary_rub'].ToFloat - salMean) <= 3 * salStd);

  writelnFormat('После удаления выбросов (Z-score < 3): {0} строк', df.RowCount);
  writeln;

  // 5. Кодируем категориальные признаки
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

  // 6. Модель: признаки + posted_month
  var X := df.ToMatrix(['experience_years', 'grade', 'specialization', 'city',
                        'work_format', 'company_segment', 'education', 'posted_month']);
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
  writeln('Примечание: OrdinalEncoder для city навязывает порядок.');
  writeln('Для неупорядоченных категорий предпочтительнее OneHotEncoder.');
end.
