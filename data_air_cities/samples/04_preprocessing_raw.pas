uses MLABC;

// Полный пайплайн предобработки данных и построение baseline
// Демонстрирует: замену скрытых пропусков, кодирование, масштабирование, обучение
//
// В данных Росгидромета пропуски закодированы как -1.0 (скрытые пропуски).
// Imputer заменяет только явные NA, поэтому -1.0 остаются как есть.
// Для baseline это приемлемо — модель учится игнорировать -1.0 как значения.

begin
  // 1. Загрузка данных
  var df := DataFrame.FromCSV('../data/data_air_cities_raw.csv');
  Writeln('Загружено строк: ', df.RowCount);
  
  // 2. Заполнение явных пропусков (NA) в признаках медианой
  Writeln('=== Заполнение пропусков (Imputer) ===');
  var imputer := new Imputer(ImputeStrategy.isMedian, ['air_solid_emissions', 'air_so_emissions', 'air_no_emissions', 'air_population']);
  df := imputer.FitTransform(df);
  Writeln('Явные пропуски (NA) заполнены медианой');
  Writeln('Скрытые пропуски (-1.0) остаются как есть для демонстрации');
  
  // 3. Добавление признака sanpin_era (изменения СанПиН)
  Writeln('=== Добавление sanpin_era ===');
  df := df.WithColumnInt('sanpin_era', row ->
    begin
      var y := row['year'];
      if y < 2014 then Result := 0
      else if y < 2021 then Result := 1
      else Result := 2;
    end);
  Writeln('Признак sanpin_era добавлен');
  
  // 4. Кодирование категориального признака region
  Writeln('=== Кодирование region ===');
  var encoder := new OrdinalEncoder('region');
  df := encoder.FitTransform(df);
  Writeln('region закодирован порядковым кодом');
  
  // 5. Отбор признаков для регрессии
  var featureCols := |'year', 'region_oktmo', 'sanpin_era',
                      'air_solid_emissions', 'air_so_emissions',
                      'air_no_emissions', 'air_population'|;
  var targetCol := 'air_co_emissions';
  
  // 6. Фильтрация: удаляем строки, где target = -1.0 (скрытый пропуск)
  //    .IsValid защищает от явных NA в столбце
  df := df.Filter(row -> row[targetCol].IsValid and (row[targetCol] <> -1.0));
  
  // 7. Извлечение матрицы признаков и целевой переменной
  var X := df.ToMatrix(featureCols);
  var y := df.ToMatrix([targetCol]).GetCol(0);
  
  // 8. Разделение на обучающую и тестовую выборки
  var (X_train, X_test, y_train, y_test) :=
    Validation.TrainTestSplit(X, y, 0.2, 42);
  
  // 9. Масштабирование признаков
  var scaler := new StandardScaler();
  X_train := scaler.FitTransform(X_train);
  X_test := scaler.Transform(X_test);
  
  // 10. Обучение модели
  var model := new KNNRegressor(7);
  model.Fit(X_train, y_train);
  
  // 11. Предсказание и оценка
  var y_pred := model.Predict(X_test);
  
  var r2 := Metrics.R2(y_test, y_pred);
  var mae := Metrics.MAE(y_test, y_pred);
  var rmse := Metrics.RMSE(y_test, y_pred);
  
  Writeln('=== Результаты после предобработки ===');
  Writeln('Модель: KNNRegressor (K=7)');
  Writeln('Признаки: year, region_oktmo, sanpin_era, emissions (3), population');
  Writeln('R2:  ', r2);
  Writeln('MAE: ', mae);
  Writeln('RMSE:', rmse);
end.