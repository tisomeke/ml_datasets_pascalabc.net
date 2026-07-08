uses MLABC;

begin
  var df := DataFrame.FromCSV('../data/mobile_tariff.csv');
  
  writeln('=== Схема данных и типы признаков ===');
  df.Schema.Print;
  
  writeln;
  writeln('=== Первичный статистический анализ ===');
  df.Describe().Print;
end.