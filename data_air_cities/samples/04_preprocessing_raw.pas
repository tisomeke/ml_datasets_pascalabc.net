uses MLABC;

// Пайплайн предобработки + baseline
// Демонстрирует: кодирование region, sanpin_era, масштабирование
//
// Внимание: -1.0 — скрытые пропуски. Imputer их не трогает.
// KNN чувствителен к -1.0 (искажает расстояния).
// В реальном проекте: замена -1.0 → NA → Imputer.

begin
  // 1. Загрузка данных
  var df := DataFrame.FromCsv('../data/data_air_cities_raw.csv');
  Writeln('Загружено строк: ', df.RowCount);
  
  // 2. Заполняем явные NA медианой
  Writeln('=== Заполнение пропусков (Imputer) ===');
  var imputer := new Imputer(ImputeStrategy.isMedian, ['air_solid_emissions', 'air_so_emissions', 'air_no_emissions', 'air_population']);
  df := imputer.FitTransform(df);
  Writeln('Явные NA заполнены медианой');
  Writeln('Скрытые пропуски (-1.0) не заменены — искажают KNN');
  
  // 3. Добавляем sanpin_era (изменения СанПиН в 2014 и 2021)
  Writeln('=== Добавление sanpin_era ===');
  df := df.WithColumnInt('sanpin_era', row ->
    begin
      var y := row['year'];
      if y < 2014 then Result := 0
      else if y < 2021 then Result := 1
      else Result := 2;
    end);
  Writeln('sanpin_era добавлен');
  
  // 4. Кодируем region (OrdinalEncoder)
  Writeln('=== Кодирование region ===');
  var encoder := new OrdinalEncoder('region');
  df := encoder.FitTransform(df);
  Writeln('region закодирован');
  
  // 5. Признаки для регрессии (region_oktmo исключён — дублирует region)
  var featureCols := |'year', 'sanpin_era',
                      'air_solid_emissions', 'air_so_emissions',
                      'air_no_emissions', 'air_population'|;
  var targetCol := 'air_co_emissions';
  
  // 6. Удаляем строки с -1.0 в target
  df := df.Filter(row -> row[targetCol].IsValid and (row[targetCol] <> -1.0));
  
  // 7. Матрица признаков и целевая
  var X := df.ToMatrix(featureCols);
  var y := df.ToMatrix([targetCol]).GetCol(0);
  
  // 8. Разделение 80/20
  var (X_train, X_test, y_train, y_test) :=
    Validation.TrainTestSplit(X, y, 0.2, 42);
  
  // 9. Масштабирование
  var scaler := new StandardScaler();
  X_train := scaler.FitTransform(X_train);
  X_test := scaler.Transform(X_test);
  
  // 10. KNN-регрессия
  var model := new KNNRegressor(7);
  model.Fit(X_train, y_train);
  
  // 11. Предсказание
  var y_pred := model.Predict(X_test);
  
  var r2 := Metrics.R2(y_test, y_pred);
  var mae := Metrics.MAE(y_test, y_pred);
  var rmse := Metrics.RMSE(y_test, y_pred);
  
  Writeln('=== Результаты после предобработки ===');
  Writeln('Модель: KNNRegressor (K=7)');
  Writeln('Признаки: year, sanpin_era, emissions (3), population');
  Writeln('R2:  ', r2);
  Writeln('MAE: ', mae);
  Writeln('RMSE:', rmse);
end.