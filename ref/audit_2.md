# Audit #2: mobile_tariff — минимальный датасет

**Дата:** 09.07.2026
**Аудитор:** SourceCraft Code Assistant (Debug mode)
**Версия датасета:** mobile_tariff v1.0

---

## Проверенные артефакты

- [`requirements/Минимальный датасет.md`](../requirements/Минимальный датасет.md)
- [`mobile_tariff/data/mobile_tariff.csv`](../mobile_tariff/data/mobile_tariff.csv)
- [`mobile_tariff/meta/mobile_tariff.meta`](../mobile_tariff/meta/mobile_tariff.meta)
- [`mobile_tariff/report/quality_report.md`](../mobile_tariff/report/quality_report.md)
- [`mobile_tariff/report/README.md`](../mobile_tariff/report/README.md)
- [`mobile_tariff/report/sources.md`](../mobile_tariff/report/sources.md)
- [`mobile_tariff/report/ai_log.md`](../mobile_tariff/report/ai_log.md)
- [`mobile_tariff/samples/01_load_dataset.pas`](../mobile_tariff/samples/01_load_dataset.pas)
- [`mobile_tariff/samples/02_describe_dataset.pas`](../mobile_tariff/samples/02_describe_dataset.pas)
- [`mobile_tariff/samples/03_baseline_model.pas`](../mobile_tariff/samples/03_baseline_model.pas)
- [`ref/pascalabcnet-github-io-docs.md`](../ref/pascalabcnet-github-io-docs.md) (документация MLABC)

---

## Critical Issues

### 1. 🔴 `quality_report.md` — неверное среднее значение price_rub

**Проблема:** В [`mobile_tariff/report/quality_report.md:31`](../mobile_tariff/report/quality_report.md:31) указано:
> «Мин: ~141 руб., макс: ~840 руб., среднее: ~355 руб.»

**Фактические значения:**
| Метрика | Факт | Заявлено |
|---------|------|----------|
| Мин | 152.61 | ~141 |
| Макс | 820.27 | ~840 |
| **Среднее** | **475.33** | **~355** |

Расхождение по среднему: **120 руб. (34%)** — это не «~», а грубая ошибка. Минимальное и максимальное значения в пределах погрешности, но среднее отличается кардинально.

**Причина:** Вероятно, среднее было посчитано на старой версии данных или ошибочно округлено.

**Решение:** Исправить `quality_report.md`:
```markdown
- Мин: ~153 руб., макс: ~820 руб., среднее: ~475 руб.
```

---

### 2. 🔴 `ai_log.md` — ложное утверждение о `04_preprocessing_raw.pas`

**Проблема:** В [`mobile_tariff/report/ai_log.md:28`](../mobile_tariff/report/ai_log.md:28) указано:
> «Запуск примеров программ (01_load_dataset, 02_describe_dataset, 03_baseline_model, **04_preprocessing_raw**)»

Но файл [`mobile_tariff/samples/04_preprocessing_raw.pas`](../mobile_tariff/samples/04_preprocessing_raw.pas) **не существует** в структуре проекта. В папке `samples/` только 3 файла:
- `01_load_dataset.pas`
- `02_describe_dataset.pas`
- `03_baseline_model.pas`

**Риск:** Это указывает на то, что ручная проверка, описанная в ai_log, не была выполнена в полном объёме, либо отчёт скопирован из другого проекта без адаптации.

**Решение:** Удалить упоминание `04_preprocessing_raw` из `ai_log.md`, либо создать файл, если он предполагался.

---

### 3. 🔴 `DataFrame.FromCSV` — несовпадение регистра с документацией (дубликат issue из Audit #1)

**Файлы:** Все 3 sample-файла mobile_tariff.

**Код:**
```pascal
var df := DataFrame.FromCSV('../data/mobile_tariff.csv');
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:4495`](ref/pascalabcnet-github-io-docs.md:4495) использует `DataFrame.FromCsv`.

**Риск:** В PascalABC.NET имена методов регистрочувствительны. Если метод называется `FromCsv`, то `FromCSV` вызовет ошибку компиляции.

---

## Improvements

### 4. 🟡 `quality_report.md` — неверные доли бинарных признаков

**Проблема:** В [`mobile_tariff/report/quality_report.md:26-28`](../mobile_tariff/report/quality_report.md:26) указано:
> - `roaming_flag`: 20% тарифов
> - `rollover_flag`: 32%
> - `messenger_unlimited_flag`: 48%

**Фактические значения:**
| Признак | Факт | Заявлено |
|---------|------|----------|
| `roaming_flag` | **47%** (47/100) | 20% |
| `rollover_flag` | **50%** (50/100) | 32% |
| `messenger_unlimited_flag` | **53%** (53/100) | 48% |

Все три значения не соответствуют действительности. Расхождение по `roaming_flag` — 27 процентных пунктов.

**Решение:** Исправить в `quality_report.md`:
```markdown
- `roaming_flag`: 47% тарифов
- `rollover_flag`: 50%
- `messenger_unlimited_flag`: 53%
```

---

### 5. 🟡 `quality_report.md` — результаты модели не соответствуют коду

**Проблема:** В [`mobile_tariff/report/quality_report.md:43-48`](../mobile_tariff/report/quality_report.md:43) указаны результаты:
> | R² | 0.71 |
> | MAE | 65.68 руб. |
> | RMSE | 82.40 руб. |

Но в [`mobile_tariff/samples/03_baseline_model.pas`](../mobile_tariff/samples/03_baseline_model.pas) **нет `seed`** в `TrainTestSplit`:
```pascal
var (X_train, X_test, y_train, y_test) :=
  Validation.TrainTestSplit(X, y, testRatio := 0.2);
```

Без `seed` результаты **невоспроизводимы** — при каждом запуске будет разное разбиение и, соответственно, разные метрики. Указанные в отчёте значения могли быть получены при одной конкретной случайной итерации.

**Решение:** Добавить `seed := 42` в `TrainTestSplit` и перезапустить модель для фиксации результатов, либо указать в отчёте, что результаты усреднены по N запускам.

---

### 6. 🟡 `README.md` — не указана формула ценообразования в доступном виде

**Проблема:** В [`mobile_tariff/report/README.md:32-34`](../mobile_tariff/report/README.md:32) формула приведена в LaTeX, но нет её текстовой расшифровки. Для студентов, не знакомых с LaTeX-нотацией, формула может быть непонятна.

**Решение:** Добавить текстовое описание:
```markdown
price_rub = 100 + 7 × internet_gb + 0.05 × voice_minutes + 0.02 × sms_count
           + 120 × roaming_flag + 60 × rollover_flag + 80 × messenger_unlimited_flag
           + 0.03 × internet_gb² + шум
```

---

### 7. 🟡 `meta` — `variant` указан как `easy`, хотя это единственная версия

**Проблема:** В [`mobile_tariff/meta/mobile_tariff.meta:6`](../mobile_tariff/meta/mobile_tariff.meta:6):
```
variant easy
```

Для минимального датасета нет множественных версий (easy/medium/raw). Указание `easy` может ввести в заблуждение, создавая ожидание других версий.

**Решение:** Либо оставить как есть (если планируются другие версии), либо изменить на `base` или `single`.

---

### 8. 🟢 Что уже хорошо

| Аспект | Статус |
|--------|--------|
| Формат CSV (UTF-8, запятая, snake_case, латиница) | ✅ |
| Мета-файл полный и соответствует данным | ✅ |
| 100 строк (в диапазоне 20-100 для минимального датасета) | ✅ |
| 6 признаков + target (в диапазоне 5-10) | ✅ |
| Пропусков нет (соответствует описанию) | ✅ |
| Задача регрессии с четкой целевой переменной | ✅ |
| Данные синтетические, PII отсутствуют | ✅ |
| Формула ценообразования работает (mean residual ~1.68, std ~23.58 ≈ 25) | ✅ |
| `sources.md` корректен | ✅ |
| `README.md` содержит все обязательные разделы | ✅ |

---

## Deep Audit: Samples vs MLABC Documentation

### 9. 🟡 `03_baseline_model.pas` — отсутствует `seed` в `TrainTestSplit`

**Файл:** [`mobile_tariff/samples/03_baseline_model.pas:23`](../mobile_tariff/samples/03_baseline_model.pas:23)

**Код:**
```pascal
var (X_train, X_test, y_train, y_test) :=
  Validation.TrainTestSplit(X, y, testRatio := 0.2);
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:214`](ref/pascalabcnet-github-io-docs.md:214) использует `seed`:
```pascal
Validation.TrainTestSplit(X, y, testRatio := 0.2, seed := 2);
```

**Риск:** Без `seed` результаты невоспроизводимы. Студент не сможет сверить свои результаты с отчётом.

**Решение:** Добавить `seed := 42`.

---

### 10. 🟢 `WithColumnInt` — корректное использование

**Файл:** [`mobile_tariff/samples/03_baseline_model.pas:7-9`](../mobile_tariff/samples/03_baseline_model.pas:7)

**Код:**
```pascal
df := df.WithColumnInt('roaming_int', r -> r['roaming_flag'].ToString() = 'true' ? 1 : 0);
```

**Документация:** [`ref/pascalabcnet-github-io-docs.md:1534`](ref/pascalabcnet-github-io-docs.md:1534) — полное соответствие. ✅

---

### 11. 🟢 `ToCSV` — корректное использование

**Файл:** [`mobile_tariff/samples/03_baseline_model.pas:12`](../mobile_tariff/samples/03_baseline_model.pas:12)

**Код:**
```pascal
df.ToCSV('../data/mobile_tariff_processed.csv');
```

Метод `ToCSV` не документирован в явном виде в [`ref/pascalabcnet-github-io-docs.md`](ref/pascalabcnet-github-io-docs.md), но является ожидаемым симметричным методом к `FromCsv`. Если API следует общей конвенции — корректен. ⚠️ Стоит проверить регистр: `ToCSV` vs `ToCsv`.

---

### 12. 🟢 `StandardScaler`, `KNNRegressor`, `Metrics` — корректное использование

Все три API используются в [`mobile_tariff/samples/03_baseline_model.pas`](../mobile_tariff/samples/03_baseline_model.pas) в полном соответствии с документацией. ✅

---

## Verdict — статус исправлений

| № | Проблема | Статус | Комментарий |
|---|----------|--------|-------------|
| 1 | `quality_report.md` — неверное среднее price_rub (355→475) | ✅ Исправлено | Среднее исправлено на ~475 руб. |
| 2 | `ai_log.md` — ложное упоминание `04_preprocessing_raw.pas` | ✅ Исправлено | Упоминание удалено |
| 3 | `DataFrame.FromCSV` vs `FromCsv` | ✅ Не требует правок | Компилятор принимает `FromCSV` |
| 4 | `quality_report.md` — неверные доли бинарных признаков | ✅ Исправлено | roaming_flag 47%, rollover_flag 50%, messenger_unlimited_flag 53% |
| 5 | `quality_report.md` — результаты модели без seed | ✅ Исправлено | Добавлен seed=42, K=7, метрики пересчитаны |
| 6 | `README.md` — формула без текстовой расшифровки | ✅ Исправлено | Добавлена текстовая версия формулы |
| 7 | `variant: easy` в meta | ✅ Исправлено | Изменено на `variant base` |
| 8 | `03_baseline_model.pas` — отсутствует seed | ✅ Исправлено | Добавлен `seed := 42` |
| 9 | `ToCSV` vs `ToCsv` — регистр | ✅ Не требует правок | `ToCSV` компилируется |

### Результаты запуска

| Файл | R² | MAE | RMSE |
|------|----|-----|------|
| `03_baseline_model.pas` (mobile_tariff, K=7, seed=42) | 0.4028 | 73.08 руб. | 94.10 руб. |