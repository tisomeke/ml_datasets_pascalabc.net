uses MLABC;

begin
  var df := DataFrame.FromCsv('../data/it_salary_easy.csv');

  writeln('=== Схема данных и типы признаков ===');
  df.Schema.Print;

  writeln;
  writeln('=== Первичный статистический анализ ===');
  df.Describe().Print;
end.
