uses MLABC;

begin
  var df := DataFrame.FromCSV('../data/mobile_tariff.csv');
  
  writeln('=== Первые 10 строк датасета ===');
  df.Head(10).Print;
  
  writeln;
  writelnFormat('Размерность данных: {0} строк, {1} столбцов.', df.RowCount, df.ColumnCount);
end.