# Audit #1: it_salary_medium — завершение среднего датасета

**Дата:** 09.07.2026
**Аудитор:** SourceCraft Code Assistant (Debug mode)
**Версия датасета:** it_salary_medium v1.0

---

## Проверенные артефакты

- [`requirements/Средний датасет.md`](../requirements/Средний датасет.md)
- [`it_salary/data/it_salary_medium.csv`](../it_salary/data/it_salary_medium.csv)
- [`it_salary/meta/it_salary_medium.meta`](../it_salary/meta/it_salary_medium.meta)
- [`it_salary/report/quality_report.md`](../it_salary/report/quality_report.md)
- [`it_salary/report/ai_log.md`](../it_salary/report/ai_log.md)
- [`it_salary/report/README.md`](../it_salary/report/README.md)
- [`it_salary/report/sources.md`](../it_salary/report/sources.md)
- [`it_salary/samples/01_load_dataset.pas`](../it_salary/samples/01_load_dataset.pas)
- [`it_salary/samples/02_describe_dataset.pas`](../it_salary/samples/02_describe_dataset.pas)
- [`it_salary/samples/03_baseline_model.pas`](../it_salary/samples/03_baseline_model.pas)
- [`it_salary/samples/04_preprocessing_raw.pas`](../it_salary/samples/04_preprocessing_raw.pas)
- [`it_salary/data/it_salary_easy.csv`](../it_salary/data/it_salary_easy.csv) (кросс-проверка)
- [`it_salary/data/it_salary_raw.csv`](../it_salary/data/it_salary_raw.csv) (кросс-проверка)
- [`requirements/Требования к CSV-файлам.md`](../requirements/Требования к CSV-файлам.md)
- [`requirements/Требования к примерам программ.md`](../requirements/Требования к примерам программ.md)
- [`requirements/Формат meta-файла.md`](../requirements/Формат meta-файла.md)
- [`requirements/Форма отчётных материалов.md`](../requirements/Форма отчётных материалов.md)
- [`ref/pascalabcnet-github-io-docs.md`](../ref/pascalabcnet-github-io-docs.md) (документация MLABC)

---

## Critical Issues

### 1. 🔴 Отсутствует sample-программа для medium-версии

**Проблема:** Все 4 файла в [`it_salary/samples/`](../it_salary/samples/) загружают только **easy** или **raw** версию:

| Файл | Загружает | Строка |
|------|-----------|--------|
| [`01_load_dataset.pas`](../it_salary/samples/01_load_dataset.pas) | `it_salary_easy.csv` | 4 |
| [`02_describe_dataset.pas`](../it_salary/samples/02_describe_dataset.pas) | `it_salary_easy.csv` | 4 |
| [`03_baseline_model.pas`](../it_salary/samples/03_baseline_model.pas) | `it_salary_easy.csv` | 4 |
| [`04_preprocessing_raw.pas`](../it_salary/samples/04_preprocessing_raw.pas) | `it_salary_raw.csv` | 4 |

**Нарушение:** [`requirements/Требования к примерам программ.md`](../requirements/Требования к примерам программ.md) — примеры должны демонстрировать ключевые этапы работы с данными. Для medium-версии это:
- Обработка пропусков (`Imputer`)
- Парсинг `posted_date` (извлечение месяца/года из DateTime)
- Построение модели на предобработанных данных

**Решение:** Создать [`it_salary/samples/05_preprocessing_medium.pas`](../it_salary/samples/05_preprocessing_medium.pas) (см. предложенный код в п.1 отчёта).

---

### 2. 🔴 `posted_date` не содержит пропусков (0%)

**Проблема:** В [`it_salary_medium.csv`](../it_salary/data/it_salary_medium.csv) столбец `posted_date` имеет **0 NA из 750 (0%)**. Это расходится с концепцией medium-версии, которая должна содержать типичные проблемы данных, включая пропуски.

**Обоснование:** Согласно [`requirements/Средний датасет.md:15-17`](../requirements/Средний датасет.md:15):
> «Версия с типичными проблемами данных. Присутствуют пропуски и категориальные признаки. Могут встречаться признаки типа DateTime.»

**Решение:** Добавить ~5-7% пропусков в `posted_date` (37-52 NA из 750) для единообразия с остальными признаками.

---

### 3. 🟡 `quality_report.md` не упоминает `posted_date` в таблице пропусков

**Проблема:** В [`it_salary/report/quality_report.md:43-48`](../it_salary/report/quality_report.md:43) таблица пропусков для medium-версии показывает только 3 столбца:
- `experience_years` ~7%
- `education` ~7%
- `work_format` ~7%

Но `posted_date` указан как `DateTime` в мета-файле — это отдельный тип, требующий упоминания в отчёте.

**Решение:** Добавить в отчёт раздел о DateTime-признаке.

---

## Improvements

### 4. 🟡 `experience_years` имеет 8.4% NA, что выходит за рамки «~7%»

| Признак | NA | % | Заявлено |
|---------|----|---|----------|
| `experience_years` | 63 | **8.4%** | ~7% |
| `education` | 56 | 7.5% | ~7% |
| `work_format` | 56 | 7.5% | ~7% |

**Рекомендация:** Выровнять количество NA до 56-57 в каждом столбце, либо скорректировать `quality_report.md`.

---

### 5. 🟡 В `README.md` нет упоминания о `seed` для воспроизводимости

**Рекомендация:** Добавить примечание о `seed := 42` при разбиении на train/test.

---

### 6. 🟡 Упоминание `scripts/generate.py` без наличия файла

**Рекомендация:** Либо добавить скрипт, либо убрать упоминание из `sources.md`.

---

### 7. 🟢 Что уже хорошо

| Аспект | Статус |
|--------|--------|
| Формат CSV (UTF-8, запятая, snake_case, латиница) | ✅ |
| Мета-файл полный и соответствует данным | ✅ |
| Нет пересечения строк между easy и medium (0 дубликатов) | ✅ |
| Зарплаты по грейдам реалистичны | ✅ |
| NA распределены случайно (равномерно по модулю 10) | ✅ |
| Диапазон дат: 2025-01 — 2026-06, покрытие по всем месяцам | ✅ |
| 750 строк (в диапазоне 500-1000) | ✅ |
| 3 версии: easy (чистая), medium (пропуски ~7%), raw (~15% + выбросы) | ✅ |
| Отсутствие персональных данных | ✅ |
| ai_log.md заполнен корректно | ✅ |
| sources.md содержит ссылки на источники | ✅ |

---

## Deep Audit: Samples vs MLABC Documentation

Проверка каждого sample-файла на соответствие документации библиотеки MLABC ([`ref/pascalabcnet-github-io-docs.md`](ref/pascalabcnet-github-io-docs.md)).

---

### 8. 🔴 `DataFrame.FromCSV` — несовпадение регистра с документацией

**Файлы:** Все 4 sample-файла it_salary + 3 файла mobile_tariff.

**Код в samples:**
```pascal
var df := DataFrame.FromCSV('../data/it_salary_easy.csv');
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:4495`](ref/pascalabcnet-github-io-docs.md:4495) использует `DataFrame.FromCsv` (строчная `sv`):
```pascal
var df := DataFrame.FromCsv('students.csv');
```

**Риск:** В PascalABC.NET имена методов регистрочувствительны. Если метод называется `FromCsv`, то `FromCSV` вызовет ошибку компиляции. Необходимо уточнить актуальный API.

**Рекомендация:** Проверить в среде PascalABC.NET, какой вариант корректен. Если `FromCsv` — исправить во всех 7 файлах (4 it_salary + 3 mobile_tariff).

---

### 9. 🟡 `df.Schema.Print` — недокументированный API

**Файл:** [`it_salary/samples/02_describe_dataset.pas:7`](../it_salary/samples/02_describe_dataset.pas:7)

**Код:**
```pascal
df.Schema.Print;
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:4546`](ref/pascalabcnet-github-io-docs.md:4546) использует `PrintInfo`:
```pascal
df.PrintInfo;
```

**Риск:** Свойство `Schema` не упоминается в документации. Если оно существует — это недокументированная возможность. Если нет — код не скомпилируется.

**Рекомендация:** Заменить на `df.PrintInfo;` для соответствия документированному API, либо оставить оба варианта, если `Schema` — валидный синоним.

---

### 10. 🟡 `OrdinalEncoder` для KNNRegressor — потенциально неоптимальный выбор

**Файлы:** [`it_salary/samples/03_baseline_model.pas:8-13`](../it_salary/samples/03_baseline_model.pas:8), [`04_preprocessing_raw.pas:44-49`](../it_salary/samples/04_preprocessing_raw.pas:44)

**Код:**
```pascal
df := new OrdinalEncoder('grade').FitTransform(df);
df := new OrdinalEncoder('specialization').FitTransform(df);
// ... и т.д. для всех 6 категориальных признаков
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:5959`](ref/pascalabcnet-github-io-docs.md:5959):
> «Для линейных моделей и методов, основанных на расстояниях, чаще лучше `OneHotEncoder».`

KNN — метод, основанный на расстояниях. `OrdinalEncoder` создаёт ложный порядок (например, `intern=0, junior=1, middle=2, senior=3, lead=4`), что искажает метрику расстояния. Разница между `intern` и `lead` (4 единицы) будет воспринята как в 4 раза больше, чем между `intern` и `junior` (1 единица), хотя реальной градации в числах нет.

**Рекомендация:** Для учебных целей `OrdinalEncoder` допустим как упрощение, но в `quality_report.md` и `README.md` стоит добавить примечание:
> «В примерах используется `OrdinalEncoder` для простоты. Для production-решений с KNN рекомендуется `OneHotEncoder`, так как он не создаёт ложного порядка категорий.»

---

### 11. 🔴 `DataFrame.Quantile` — отсутствует в документации

**Файл:** [`it_salary/samples/04_preprocessing_raw.pas:32-33`](../it_salary/samples/04_preprocessing_raw.pas:32)

**Код:**
```pascal
var q1 := DataFrame.Quantile(df, 'salary_rub', 0.25);
var q3 := DataFrame.Quantile(df, 'salary_rub', 0.75);
```

**Документация:** Метод `Quantile` **не найден** в [`ref/pascalabcnet-github-io-docs.md`](ref/pascalabcnet-github-io-docs.md). Ни как статический метод `DataFrame.Quantile`, ни как метод экземпляра.

**Риск:** Высокий. Если метод не существует в актуальной версии MLABC, пример [`04_preprocessing_raw.pas`](../it_salary/samples/04_preprocessing_raw.pas) не скомпилируется. Это критично, так как raw-версия останется без работающего примера предобработки.

**Рекомендация:**
1. Уточнить у вас: «Покажи документацию по методу `Quantile` из MLABC.»
2. Если метод отсутствует — заменить на ручной расчёт через сортировку и процентили, либо использовать `Describe` + ручное извлечение Q1/Q3.

---

### 12. 🟡 `mobile_tariff` samples используют `DataFrame.FromCSV` (тот же паттерн)

**Файлы:** [`mobile_tariff/samples/01_load_dataset.pas:4`](../mobile_tariff/samples/01_load_dataset.pas:4), [`02_describe_dataset.pas:4`](../mobile_tariff/samples/02_describe_dataset.pas:4), [`03_baseline_model.pas:4`](../mobile_tariff/samples/03_baseline_model.pas:4)

Проблема та же, что в п.8 — `FromCSV` вместо `FromCsv`. Если API регистрочувствителен, ошибка дублируется и в минимальном датасете.

---

### 13. 🟢 `Imputer` — корректное использование

**Файл:** [`it_salary/samples/04_preprocessing_raw.pas:21-25`](../it_salary/samples/04_preprocessing_raw.pas:21)

**Код:**
```pascal
df := new Imputer(ImputeStrategy.isMedian, ['experience_years']).FitTransform(df);
df := new Imputer('unknown', ['work_format']).FitTransform(df);
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:6211-6217`](ref/pascalabcnet-github-io-docs.md:6211) — полное совпадение сигнатур:
- `Imputer(ImputeStrategy.isMedian, ['Возраст'])` ✅
- `Imputer('Не указан', ['Отдел'])` ✅

**Вердикт:** ✅ Корректно.

---

### 14. 🟢 `StandardScaler` + `FitTransform` / `Transform` — корректное использование

**Файлы:** [`it_salary/samples/03_baseline_model.pas:27-29`](../it_salary/samples/03_baseline_model.pas:27), [`04_preprocessing_raw.pas:59-61`](../it_salary/samples/04_preprocessing_raw.pas:59)

**Код:**
```pascal
var scaler := new StandardScaler();
var X_train_scaled := scaler.FitTransform(X_train);
var X_test_scaled := scaler.Transform(X_test);
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:6515-6517`](ref/pascalabcnet-github-io-docs.md:6515) — полное совпадение паттерна. `FitTransform` на train, `Transform` на test. ✅

---

### 15. 🟢 `TrainTestSplit` — корректное использование

**Файлы:** [`it_salary/samples/03_baseline_model.pas:23-24`](../it_salary/samples/03_baseline_model.pas:23), [`04_preprocessing_raw.pas:56-57`](../it_salary/samples/04_preprocessing_raw.pas:56)

**Код:**
```pascal
var (X_train, X_test, y_train, y_test) :=
  Validation.TrainTestSplit(X, y, testRatio := 0.2, seed := 42);
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:214`](ref/pascalabcnet-github-io-docs.md:214) — полное совпадение сигнатуры. ✅

---

### 16. 🟢 `KNNRegressor` — корректное использование

**Файлы:** [`it_salary/samples/03_baseline_model.pas:32`](../it_salary/samples/03_baseline_model.pas:32), [`04_preprocessing_raw.pas:63`](../it_salary/samples/04_preprocessing_raw.pas:63)

**Код:**
```pascal
var model := new KNNRegressor(5);
model.Fit(X_train_scaled, y_train);
var pred := model.Predict(X_test_scaled);
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:6592`](ref/pascalabcnet-github-io-docs.md:6592) — `KNNRegressor` упомянут как поддерживаемая модель. Паттерн `Fit` + `Predict` стандартный. ✅

---

### 17. 🟢 `WithColumnInt` — корректное использование в предложенном sample

**Файл:** (предложенный) [`it_salary/samples/05_preprocessing_medium.pas`](../it_salary/samples/05_preprocessing_medium.pas)

**Код:**
```pascal
df := df.WithColumnInt('post_month', r -> r['posted_date'].ToString().Substring(5, 2).ToInteger);
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:1534`](ref/pascalabcnet-github-io-docs.md:1534):
> «Методы `WithColumn...` добавляют новый столбец. Суффикс в имени метода задаёт тип нового столбца: например, `WithColumnBool`, `WithColumnInt`, `WithColumnFloat`, `WithColumnString».»

Паттерн `df := df.WithColumnInt('name', row -> ...)` полностью соответствует документации. ✅

---

### Сводка по samples

| Файл | API | Статус |
|------|-----|--------|
| `01_load_dataset.pas` | `FromCSV`, `Head`, `Print` | 🟡 `FromCSV` vs `FromCsv` |
| `02_describe_dataset.pas` | `FromCSV`, `Schema.Print`, `Describe` | 🟡 `Schema` недокументирован |
| `03_baseline_model.pas` | `FromCSV`, `OrdinalEncoder`, `ToMatrix`, `TrainTestSplit`, `StandardScaler`, `KNNRegressor`, `Metrics` | 🟡 `OrdinalEncoder` + KNN (см. п.10) |
| `04_preprocessing_raw.pas` | `FromCSV`, `Drop`, `MissingCounts`, `Imputer`, `DataFrame.Quantile`, `Filter`, `OrdinalEncoder`, ... | 🔴 `Quantile` не найден в docs |
| `05_preprocessing_medium.pas` | (предложен) `FromCSV`, `MissingCounts`, `Imputer`, `WithColumnInt`, `Drop`, `OrdinalEncoder`, ... | 🟢 `WithColumnInt` ✅, остальное — см. замечания выше |

---

## Verdict — статус исправлений

| № | Проблема | Статус | Комментарий |
|---|----------|--------|-------------|
| 1 | Sample для medium-версии | ❌ Не исправлено | По требованию пользователя — `05_preprocessing_medium.pas` удалён |
| 2 | `posted_date` без пропусков | ❌ Не исправлено | Данные не изменялись. Добавлено упоминание в `quality_report.md` |
| 3 | `quality_report.md` без posted_date | ✅ Исправлено | Добавлена секция DateTime-признак |
| 4 | `experience_years` 8.4% NA | ✅ Исправлено | В `quality_report.md` указано ~8% |
| 5 | README без seed | ✅ Исправлено | Добавлено примечание о seed=42 |
| 6 | `scripts/generate.py` в sources.md | ✅ Исправлено | Упоминание удалено |
| 7 | `FromCSV` vs `FromCsv` | ✅ Не требует правок | Компилятор принимает `FromCSV` |
| 8 | `Schema.Print` vs `PrintInfo` | ✅ Не требует правок | `Schema.Print` компилируется |
| 9 | `OrdinalEncoder` + KNN | ❌ Не исправлено | Оставлено как учебное упрощение |
| 10 | `DataFrame.Quantile` | ✅ Исправлено | Заменён на Z-score (Mean+Std+Filter) |
| 11 | `03_baseline_model.pas` синтаксис | ✅ Исправлено | Разделены цепочки `new Class().Method()` |
| 12 | `04_preprocessing_raw.pas` синтаксис | ✅ Исправлено | Разделены цепочки + Quantile -> Z-score |
| 13 | `experience_years` float→int | ✅ Исправлено | Все 3 CSV + 3 meta + quality_report + README |

### Результаты запуска

| Файл | R² | MAE | RMSE |
|------|----|-----|------|
| `03_baseline_model.pas` (easy) | 0.6158 | 67 300 руб. | 94 034 руб. |
| `04_preprocessing_raw.pas` (raw) | 0.3108 | 77 850 руб. | 108 697 руб. |