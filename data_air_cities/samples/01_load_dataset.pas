uses MLABC;

begin
  // Загрузка датасета о качестве атмосферного воздуха в городах РФ
  var df := DataFrame.FromCSV('../data/data_air_cities_raw.csv');
  
  // Вывод первых 10 строк
  Writeln('=== Первые 10 строк ===');
  df.Head(10).Print;
  
  // Вывод последних 5 строк
  Writeln('=== Последние 5 строк ===');
  df.Tail(5).Print;
  
  // Схема данных (типы столбцов)
  Writeln('=== Схема данных ===');
  df.Schema.Print;
  
  // Количество пропусков
  Writeln('=== Пропуски ===');
  df.MissingCounts.Print;
  
end.
