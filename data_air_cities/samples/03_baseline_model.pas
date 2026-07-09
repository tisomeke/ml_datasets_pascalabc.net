uses MLABC;

// Базовая модель регрессии для задачи А: прогноз выбросов CO
// Признаки: year, air_solid_emissions, air_so_emissions, air_no_emissions, air_population
// Цель: air_co_emissions
//
// В данных Росгидромета пропуски закодированы как -1.0 (скрытые пропуски).
// Imputer заменяет только явные NA, поэтому -1.0 остаются как есть.
// Для baseline это приемлемо — модель учится игнорировать -1.0 как значения.

begin
  // 1. Загрузка данных
  var df := DataFrame.FromCSV('../data/data_air_cities_raw.csv');
  
  // 2. Отбор признаков и целевой переменной
  var featureCols := |'year', 'air_solid_emissions', 'air_so_emissions',
                      'air_no_emissions', 'air_population'|;
  var targetCol := 'air_co_emissions';
  
  // 3. Удаление строк с пропусками в целевой переменной
  //    -1.0 — скрытый пропуск (нет данных о выбросах для этого года/города)
  //    .IsValid защищает от явных NA в столбце
  df := df.Filter(row -> row[targetCol].IsValid and (row[targetCol] <> -1.0));
  
  // 4. Заполнение явных пропусков (NA) в признаках медианой
  var imputer := new Imputer(ImputeStrategy.isMedian, ['air_solid_emissions', 'air_so_emissions', 'air_no_emissions', 'air_population']);
  df := imputer.FitTransform(df);
  
  // 5. Извлечение матрицы признаков и целевой переменной
  var X := df.ToMatrix(featureCols);
  var y := df.ToMatrix([targetCol]).GetCol(0);
  
  // 6. Разделение на обучающую и тестовую выборки
  var (X_train, X_test, y_train, y_test) :=
    Validation.TrainTestSplit(X, y, 0.2, 42);
  
  // 7. Масштабирование признаков
  var scaler := new StandardScaler();
  X_train := scaler.FitTransform(X_train);
  X_test := scaler.Transform(X_test);
  
  // 8. Обучение модели KNN-регрессии
  var model := new KNNRegressor(5);
  model.Fit(X_train, y_train);
  
  // 9. Предсказание и оценка
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