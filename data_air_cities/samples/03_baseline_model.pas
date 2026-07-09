uses MLABC;

// Baseline: прогноз выбросов CO (регрессия)
// Признаки: year, emissions (solid, SO2, NO2), population
//
// Внимание: -1.0 — скрытые пропуски. Imputer не обрабатывает их.
// KNN считает расстояния, поэтому -1.0 искажает nearest neighbors.
// В реальном проекте требуется замена -1.0 → NA перед Imputer.

begin
  // 1. Загрузка данных
  var df := DataFrame.FromCsv('../data/data_air_cities_raw.csv');
  
  // 2. Признаки и целевая
  var featureCols := |'year', 'air_solid_emissions', 'air_so_emissions',
                      'air_no_emissions', 'air_population'|;
  var targetCol := 'air_co_emissions';
  
  // 3. Удаляем строки с -1.0 в target (нет данных о выбросах)
  df := df.Filter(row -> row[targetCol].IsValid and (row[targetCol] <> -1.0));
  
  // 4. Заполняем явные NA медианой
  var imputer := new Imputer(ImputeStrategy.isMedian, ['air_solid_emissions', 'air_so_emissions', 'air_no_emissions', 'air_population']);
  df := imputer.FitTransform(df);
  
  // 5. Матрица признаков и целевая
  var X := df.ToMatrix(featureCols);
  var y := df.ToMatrix([targetCol]).GetCol(0);
  
  // 6. Разделение 80/20
  var (X_train, X_test, y_train, y_test) :=
    Validation.TrainTestSplit(X, y, 0.2, 42);
  
  // 7. Масштабирование
  var scaler := new StandardScaler();
  X_train := scaler.FitTransform(X_train);
  X_test := scaler.Transform(X_test);
  
  // 8. KNN-регрессия
  var model := new KNNRegressor(5);
  model.Fit(X_train, y_train);
  
  // 9. Предсказание
  var y_pred := model.Predict(X_test);
  
  var r2 := Metrics.R2(y_test, y_pred);
  var mae := Metrics.MAE(y_test, y_pred);
  var rmse := Metrics.RMSE(y_test, y_pred);
  
  Writeln('=== Результаты baseline (KNNRegressor, K=5) ===');
  Writeln('Цель: air_co_emissions (выбросы CO, тыс. тонн)');
  Writeln('Признаки: year, air_solid_emissions, air_so_emissions, air_no_emissions, air_population');
  Writeln('R2:  ', r2);
  Writeln('MAE: ', mae);
  Writeln('RMSE:', rmse);
end.