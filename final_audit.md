# Финальный аудит — все датасеты

## 1. Структура проекта

```
ml_datasets_pascalabc.net/
├── README.md                          # Корневой README (обновлён)
├── LICENSE                            # MIT
├── requirements/                      # Шаблоны и требования (9 файлов)
├── ref/                               # Референсные материалы
│   ├── Большой экодатасет.md          # ТЗ для data_air_cities (MLABC API)
│   ├── description_air_cities_100_v20231129.pdf
│   ├── pascalabcnet-github-io-docs.md
│   ├── audit_1.md, audit_2.md
│   └── Анализ ИТ-Рынка Труда РФ.md
├── mobile_tariff/                     # МИНИМАЛЬНЫЙ датасет
├── it_salary/                         # СРЕДНИЙ датасет
└── data_air_cities/                   # БОЛЬШОЙ датасет
```

---

## 2. Минимальный датасет: mobile_tariff

### Состав
| Файл | Статус |
|------|--------|
| `data/mobile_tariff.csv` | ✅ 100 строк, 7 столбцов, UTF-8, `,` delimiter |
| `meta/mobile_tariff.meta` | ✅ variant=base, rows=100, columns=7, все поля |
| `samples/01_load_dataset.pas` | ✅ компилируется, запускается |
| `samples/02_describe_dataset.pas` | ✅ компилируется, запускается |
| `samples/03_baseline_model.pas` | ✅ компилируется, запускается (R²=0.4028) |
| `report/README.md` | ✅ цель, признаки, формула, использование |
| `report/quality_report.md` | ✅ размер, типы, пропуски, результаты |
| `report/sources.md` | ✅ синтетические, метод генерации, лицензия MIT |
| `report/ai_log.md` | ✅ инструменты, цели, ручная проверка |

### Проверка соответствия требованиям
| Требование | Статус |
|-----------|--------|
| < 100 строк (20–100) | ✅ 100 строк |
| 5–10 признаков | ✅ 6 признаков |
| Чёткая задача | ✅ регрессия (price_rub) |
| CSV: UTF-8, snake_case, латиница, `,` | ✅ |
| Целевая переменная | ✅ price_rub |
| Мета-файл | ✅ |
| Пример программы | ✅ 3 программы |
| Нет персональных данных | ✅ синтетические |
| Тема из списка | ✅ «Выбор тарифа мобильной связи» |

### Замечания
- Нет `04_preprocessing_raw.pas` — не требуется (нет raw-версии)
- `FromCSV` (uppercase CS) — работает, хотя документация использует `FromCsv`

---

## 3. Средний датасет: it_salary

### Состав
| Файл | Статус |
|------|--------|
| `data/it_salary_easy.csv` | ✅ 750 строк, 8 столбцов, без пропусков |
| `data/it_salary_medium.csv` | ✅ 750 строк, 9 столбцов, пропуски ~7%, DateTime |
| `data/it_salary_raw.csv` | ✅ 750 строк, 10 столбцов, пропуски ~15%, выбросы, текст |
| `meta/it_salary_easy.meta` | ✅ variant=easy, rows=750, columns=8 |
| `meta/it_salary_medium.meta` | ✅ variant=medium, rows=750, columns=9 |
| `meta/it_salary_raw.meta` | ✅ variant=raw, rows=750, columns=10 |
| `samples/01_load_dataset.pas` | ✅ компилируется, запускается |
| `samples/02_describe_dataset.pas` | ✅ компилируется, запускается |
| `samples/03_baseline_model.pas` | ✅ компилируется, запускается (R²=0.6328) |
| `samples/04_preprocessing_raw.pas` | ✅ компилируется, запускается (R²=0.2753) |
| `report/README.md` | ✅ цель, 3 версии, признаки, формула |
| `report/quality_report.md` | ✅ все 3 версии, пропуски, результаты |
| `report/sources.md` | ✅ синтетические, 6 источников-референсов |
| `report/ai_log.md` | ✅ инструменты, цели, ручная проверка |

### Проверка соответствия требованиям
| Требование | Статус |
|-----------|--------|
| 500–1000 объектов | ✅ 750 строк |
| 3 версии (easy, medium, raw) | ✅ |
| easy: без пропусков | ✅ |
| medium: пропуски + DateTime | ✅ |
| raw: пропуски, выбросы, текст | ✅ |
| CSV: UTF-8, snake_case, латиница, `,` | ✅ |
| Целевая переменная | ✅ salary_rub |
| Мета-файлы для каждой версии | ✅ |
| 4 sample-программы | ✅ (включая 04_preprocessing_raw) |
| Тема из списка | ✅ «Вакансии в ИТ» |

### Замечания
- `FromCsv` (lowercase) — соответствует документации
- `seed := 42` используется во всех программах — воспроизводимость ✅
- `04_preprocessing_raw.pas` корректно использует Z-score для удаления выбросов

---

## 4. Большой датасет: data_air_cities

### Состав
| Файл | Статус |
|------|--------|
| `data/data_air_cities_raw.csv` | ✅ 3992 строки, 15 столбцов, реальные данные |
| `data/data_air_cities_sample_1000.csv` | ✅ 1000 строк, 15 столбцов |
| `meta/data_air_cities_raw.meta` | ✅ variant=raw, rows=3992, columns=15 |
| `meta/data_air_cities_sample_1000.meta` | ✅ variant=sample_1000, rows=1000, columns=15 |
| `scripts/preprocess_data.py` | ✅ документирует все шаги обработки |
| `samples/01_load_dataset.pas` | ✅ компилируется, запускается |
| `samples/02_describe_dataset.pas` | ✅ компилируется, запускается |
| `samples/03_baseline_model.pas` | ✅ компилируется, запускается (R²=0.6798) |
| `samples/04_preprocessing_raw.pas` | ✅ компилируется, запускается (R²=0.6802) |
| `report/README.md` | ✅ цель, признаки, 3 задачи ML, использование |
| `report/quality_report.md` | ✅ EDA, пропуски, распределения, baseline |
| `report/sources.md` | ✅ реальные данные, CC BY, цитирование |
| `report/ai_log.md` | ✅ инструменты, цели, ручная проверка |

### Проверка соответствия требованиям
| Требование | Статус |
|-----------|--------|
| Реальные открытые данные | ✅ Росгидромет, tochno-st |
| > 1000 строк | ✅ 3992 строки |
| Сэмплы разных размеров | ✅ sample_1000 |
| Мета-файлы для каждого CSV | ✅ |
| Скрипты обработки | ✅ scripts/preprocess_data.py |
| Источники и лицензия | ✅ CC BY, ссылки, дата обращения |
| CSV: UTF-8, snake_case, латиница, `,` | ✅ (конвертирован из `;`) |
| Целевая переменная | ✅ air_general_level (классиф.), air_co_emissions (регрессия) |
| 4 sample-программы | ✅ |
| Нет персональных данных | ✅ данные городов и регионов |
| Тема из списка | ✅ «Экологические показатели» |

### Замечания
- CSV содержит русские значения (названия городов, регионов, веществ) — это допустимо, т.к. требования запрещают русские **названия столбцов**, а не значения
- Поля с запятыми (списки веществ) корректно экранированы кавычками
- Скрытые пропуски `-1.0` (450–482 на столбец) и `-9` (473) задокументированы
- `FromCSV` (uppercase) — работает, хотя документация использует `FromCsv`

---

## 5. Сводка по sample-программам

### mobile_tariff
| Программа | Компиляция | Запуск | Результат |
|-----------|-----------|--------|-----------|
| 01_load_dataset.pas | ✅ | ✅ | Head(10), RowCount, ColumnCount |
| 02_describe_dataset.pas | ✅ | ✅ | Schema, Describe |
| 03_baseline_model.pas | ✅ | ✅ | R²=0.4028, MAE=73.08, RMSE=94.10 |

### it_salary
| Программа | Компиляция | Запуск | Результат |
|-----------|-----------|--------|-----------|
| 01_load_dataset.pas | ✅ | ✅ | Head(10), RowCount, ColumnCount |
| 02_describe_dataset.pas | ✅ | ✅ | Schema, Describe |
| 03_baseline_model.pas | ✅ | ✅ | R²=0.6328, MAE=66173, RMSE=91934 |
| 04_preprocessing_raw.pas | ✅ | ✅ | R²=0.2753, MAE=80054, RMSE=111462 |

### data_air_cities
| Программа | Компиляция | Запуск | Результат |
|-----------|-----------|--------|-----------|
| 01_load_dataset.pas | ✅ | ✅ | Head(10), Tail(5), Schema, MissingCounts |
| 02_describe_dataset.pas | ✅ | ✅ | Describe, Schema, hidden -1.0 counts |
| 03_baseline_model.pas | ✅ | ✅ | R²=0.6798, MAE=11.40, RMSE=30.78 |
| 04_preprocessing_raw.pas | ✅ | ✅ | R²=0.6802, MAE=11.66, RMSE=30.76 |

---

## 6. Проверка meta-файлов

| Файл | name | variant | rows | columns | features | target | missing | Все поля |
|------|------|---------|------|---------|----------|--------|---------|----------|
| mobile_tariff.meta | ✅ | base | 100 | 7 | ✅ | price_rub | no | ✅ |
| it_salary_easy.meta | ✅ | easy | 750 | 8 | ✅ | salary_rub | no | ✅ |
| it_salary_medium.meta | ✅ | medium | 750 | 9 | ✅ | salary_rub | yes (NA) | ✅ |
| it_salary_raw.meta | ✅ | raw | 750 | 10 | ✅ | salary_rub | yes (NA) | ✅ |
| data_air_cities_raw.meta | ✅ | raw | 3992 | 15 | ✅ | air_general_level | yes (NA, -1.0, -9, No substance, No information) | ✅ |
| data_air_cities_sample_1000.meta | ✅ | sample_1000 | 1000 | 15 | ✅ | air_general_level | yes (NA, -1.0, -9, No substance, No information) | ✅ |

---

## 7. Проверка CSV-файлов

| Файл | Строк (данных) | Столбцов | UTF-8 | `,` delimiter | snake_case | Латиница в заголовках | NA для пропусков |
|------|---------------|----------|-------|--------------|------------|----------------------|-----------------|
| mobile_tariff.csv | 100 | 7 | ✅ | ✅ | ✅ | ✅ | нет пропусков |
| it_salary_easy.csv | 750 | 8 | ✅ | ✅ | ✅ | ✅ | нет пропусков |
| it_salary_medium.csv | 750 | 9 | ✅ | ✅ | ✅ | ✅ | ✅ |
| it_salary_raw.csv | 750 | 10 | ✅ | ✅ | ✅ | ✅ | ✅ |
| data_air_cities_raw.csv | 3992 | 15 | ✅ | ✅ | ✅ | ✅ | ✅ (и -1.0, -9) |
| data_air_cities_sample_1000.csv | 1000 | 15 | ✅ | ✅ | ✅ | ✅ | ✅ (и -1.0, -9) |

---

## 8. Проверка отчётов

### README.md (каждый датасет)
| Раздел | mobile_tariff | it_salary | data_air_cities |
|--------|--------------|-----------|-----------------|
| Цель | ✅ | ✅ | ✅ |
| Предметная область | ✅ | ✅ | ✅ |
| Признаки (таблица) | ✅ | ✅ | ✅ |
| Целевая переменная | ✅ | ✅ | ✅ |
| Особенности данных | ✅ | ✅ | ✅ |
| Использование | ✅ | ✅ | ✅ |
| Примеры | ✅ | ✅ | ✅ |
| Ограничения | ✅ | ✅ | ✅ |

### quality_report.md
| Раздел | mobile_tariff | it_salary | data_air_cities |
|--------|--------------|-----------|-----------------|
| Размер | ✅ | ✅ | ✅ |
| Типы признаков | ✅ | ✅ | ✅ |
| Пропуски и выбросы | ✅ | ✅ | ✅ |
| Категориальные признаки | ✅ | ✅ | ✅ |
| Рекомендованная обработка | ✅ | ✅ | ✅ |
| Методология | ✅ | ✅ | ✅ |
| Результаты | ✅ | ✅ | ✅ |

### sources.md
| Раздел | mobile_tariff | it_salary | data_air_cities |
|--------|--------------|-----------|-----------------|
| Тип источника | ✅ синтетический | ✅ синтетический | ✅ реальные данные |
| Нет персональных данных | ✅ | ✅ | ✅ |
| Метод генерации | ✅ формула | ✅ мультипликативная модель | — |
| Источники-референсы | ✅ | ✅ 6 источников | ✅ 3 источника |
| Лицензия | ✅ MIT | ✅ MIT | ✅ CC BY |
| Дата создания | ✅ | ✅ | ✅ |

### ai_log.md
| Раздел | mobile_tariff | it_salary | data_air_cities |
|--------|--------------|-----------|-----------------|
| Инструменты | ✅ | ✅ | ✅ |
| Цели использования | ✅ | ✅ | ✅ |
| Ручная проверка | ✅ | ✅ | ✅ |

---

## 9. Итоговый вердикт

### Найдено и исправлено в ходе финального аудита
1. **data_air_cities/report/README.md** — удалён `**Статус:** WIP — черновик`
2. **data_air_cities/report/quality_report.md** — удалён `**Статус:** WIP — черновик`
3. **data_air_cities/report/ai_log.md** — удалён `**Статус:** Черновик`
4. **data_air_cities/meta/data_air_cities_raw.meta** — `task` исправлен с `regression` на `classification, regression, clustering`
5. **data_air_cities/meta/data_air_cities_sample_1000.meta** — `task` исправлен, добавлен `-9` в `missing_values`
6. **README.md (корневой)** — раздел «Большой датасет» обновлён с WIP на data_air_cities; лицензии разделены (MIT для синтетических, CC BY для реальных)

### Все датасеты соответствуют требованиям
- ✅ **Минимальный** (mobile_tariff): 100 строк, 6 признаков, регрессия, 3 sample-программы
- ✅ **Средний** (it_salary): 750 строк, 3 версии (easy/medium/raw), 4 sample-программы
- ✅ **Большой** (data_air_cities): 3992 строки, реальные данные, сэмпл, скрипты, 4 sample-программы

### Git-лог (8 коммитов поверх stubs)
```
bd85392 root README: update big dataset section, fix license for real data
249fbb1 data_air_cities: remove WIP status, fix meta task/target fields
060f559 data_air_cities: remove PDF from data/ (moved to ref/)
4ab6829 data_air_cities: update ТЗ for MLABC API, add PDF, cleanup .gitignore
2d32d1f data_air_cities: update reports with EDA and baseline results
d5a0119 data_air_cities: add 4 sample programs for ML PascalABC.NET
f97e6f5 data_air_cities: add CSV data, meta files, and preprocessing script
63866ce add data_air_cities stubs: meta, report files, scripts dir