uses MLABC;

begin
  var df := DataFrame.FromCSV('../data/mobile_tariff.csv');
  
  // Булевы признаки записаны как true/false — преобразуем в 1/0
  df := df.WithColumnInt('roaming_int', r -> r['roaming_flag'].ToString() = 'true' ? 1 : 0);
  df := df.WithColumnInt('rollover_int', r -> r['rollover_flag'].ToString() = 'true' ? 1 : 0);
  df := df.WithColumnInt('messenger_int', r -> r['messenger_unlimited_flag'].ToString() = 'true' ? 1 : 0);
  
  // Сохраняем обработанный датасет в отдельный файл (исходный CSV не изменяется)
  df.ToCSV('../data/mobile_tariff_processed.csv');
  
  // Формируем матрицу признаков
  var X := df.ToMatrix(['internet_gb', 'voice_minutes', 'sms_count',
                        'roaming_int', 'rollover_int', 'messenger_int']);
  
  // Целевая переменная
  var y := df.ToMatrix(['price_rub']).GetCol(0);
  
  // Разбиение на обучающую (80%) и тестовую (20%) выборки
  var (X_train, X_test, y_train, y_test) :=
    Validation.TrainTestSplit(X, y, testRatio := 0.2);
  
  // Масштабирование признаков
  var scaler := new StandardScaler();
  var X_train_scaled := scaler.FitTransform(X_train);
  var X_test_scaled := scaler.Transform(X_test);
  
  // Обучение модели KNN-регрессии
  var model := new KNNRegressor(3);
  model.Fit(X_train_scaled, y_train);
  
  // Предсказание
  var pred := model.Predict(X_test_scaled);
  
  // Оценка качества
  var r2 := Metrics.R2(y_test, pred);
  var mae := Metrics.MAE(y_test, pred);
  var rmse := Metrics.RMSE(y_test, pred);
  
  writeln('=== Результаты KNN-регрессии ===');
  writelnFormat('R²:  {0:F4}', r2);
  writelnFormat('MAE: {0:F2} руб.', mae);
  writelnFormat('RMSE:{0:F2} руб.', rmse);
end.