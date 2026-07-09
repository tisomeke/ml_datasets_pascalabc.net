uses MLABC;

begin
  var df := DataFrame.FromCsv('../data/mobile_tariff.csv');
  
  writeln('=== Схема данных ===');
  df.Schema.Print;
  
  writeln;
  writeln('=== Статистика ===');
  df.Describe().Print;
end.