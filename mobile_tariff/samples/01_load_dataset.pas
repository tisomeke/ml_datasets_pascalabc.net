uses MLABC;

begin
  var df := DataFrame.FromCsv('../data/mobile_tariff.csv');
  
  writeln('=== Первые 10 строк ===');
  df.Head(10).Print;
  
  writeln;
  writelnFormat('Размерность: {0} строк, {1} столбцов.', df.RowCount, df.ColumnCount);
end.