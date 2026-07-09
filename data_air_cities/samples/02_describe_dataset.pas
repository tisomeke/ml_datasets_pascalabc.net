uses MLABC;

begin
  // Загрузка датасета
  var df := DataFrame.FromCSV('../data/data_air_cities_raw.csv');
  
  // Подробное описание числовых столбцов
  Writeln('=== Статистика числовых признаков ===');
  df.Describe.Print;
  
  // Пропуски по каждому столбцу
  Writeln('=== Пропуски (явные и скрытые) ===');
  df.MissingCounts.Print;
  
  // Схема данных
  Writeln('=== Схема данных ===');
  df.Schema.Print;
  
  // Вывод информации о скрытых пропусках -1.0
  // Используем .IsValid для проверки, что значение не NA, перед сравнением
  Writeln('=== Скрытые пропуски (значение -1.0) ===');
  var hiddenSolid := df.Filter(row -> row['air_solid_emissions'].IsValid and (row['air_solid_emissions'] = -1.0)).RowCount;
  var hiddenSO := df.Filter(row -> row['air_so_emissions'].IsValid and (row['air_so_emissions'] = -1.0)).RowCount;
  var hiddenNO := df.Filter(row -> row['air_no_emissions'].IsValid and (row['air_no_emissions'] = -1.0)).RowCount;
  var hiddenCO := df.Filter(row -> row['air_co_emissions'].IsValid and (row['air_co_emissions'] = -1.0)).RowCount;
  Writeln('air_solid_emissions = -1.0: ', hiddenSolid);
  Writeln('air_so_emissions = -1.0: ', hiddenSO);
  Writeln('air_no_emissions = -1.0: ', hiddenNO);
  Writeln('air_co_emissions = -1.0: ', hiddenCO);
end.
