# Датасеты для ML библиотеки PascalABC.NET

## Структура датасета:
```
some_dataset/
├── data/
│   └── some_dataset.csv
├── meta/
│   └── some_dataset.meta
├── samples/
│   ├── 01_load_dataset.pas
│   ├── 02_describe_dataset.pas
│   └── 03_baseline_model.pas
└── report/
    ├── README.md
    ├── quality_report.md
    ├── ai_log.md
    └── sources.md
```
*Более подробная структура каждого файла описана в соответствующих файлах в [requirements/](requirements/)*

***

## Минимальный датасет ─ [mobile_tariff](mobile_tariff)
#### Цель
Предсказать цену тарифа мобильной связи по его наполнению (регрессия).

#### Предметная область
Телекоммуникации, тарифы мобильных операторов.

#### Признаки

| Признак | Тип | Роль | Смысл |
|---------|-----|------|-------|
| internet_gb | Float | Признак | Гигабайты интернета (1–50) |
| voice_minutes | Int | Признак | Минуты разговора (100–2000) |
| sms_count | Int | Признак | SMS (0–500) |
| roaming_flag | Bool | Признак | Есть роуминг? |
| rollover_flag | Bool | Признак | Перенос остатков? |
| messenger_unlimited_flag | Bool | Признак | Безлимит на мессенджеры? |
| price_rub | Float | **Цель** | Цена в рублях |

##### [CSV-файл](mobile_tariff/data/mobile_tariff.csv)
##### [Подробное описание](mobile_tariff/report/README.md)

***

## Средний датасет ─ [it_salary](it_salary)
#### Цель
Предсказать зарплату ИТ-специалиста по параметрам вакансии (регрессия).

#### Предметная область
Рынок труда в ИТ-индустрии России (2025–2026 гг.).

#### Версии
| Версия | Файл | Особенности |
|--------|------|-------------|
| easy | `it_salary_easy.csv` | Чистая, 8 столбцов, без пропусков |
| medium | `it_salary_medium.csv` | 9 столбцов, пропуски ~7%, DateTime |
| raw | `it_salary_raw.csv` | 10 столбцов, пропуски ~15%, выбросы, текст |

#### Признаки (easy-версия)

| Признак | Тип | Роль | Смысл |
|---------|-----|------|-------|
| experience_years | Int | Признак | Опыт работы в годах |
| grade | Categorical | Признак | Грейд (intern–lead) |
| specialization | Categorical | Признак | Специализация (backend, frontend...) |
| city | Categorical | Признак | Город (moscow, spb, regions) |
| work_format | Categorical | Признак | Формат работы (office, remote, hybrid) |
| company_segment | Categorical | Признак | Сегмент компании |
| education | Categorical | Признак | Требование к образованию |
| salary_rub | Float | **Цель** | Зарплата в рублях |

##### [CSV-файлы](it_salary/data/)
##### [Подробное описание](it_salary/report/README.md)

***

## Большой датасет ─ [data_air_cities](data_air_cities)
#### Цель
Анализ и прогнозирование уровня загрязнения атмосферного воздуха в городах России (регрессия, классификация, кластеризация).

#### Предметная область
Экология, качество атмосферного воздуха, промышленные выбросы.

#### Признаки

| Признак | Тип | Роль | Смысл |
|---------|-----|------|-------|
| year | Int | Признак | Год наблюдения (2007–2022) |
| region | String | Признак | Субъект РФ |
| region_oktmo | String | Признак | Код ОКТМО региона |
| city | String | Признак | Город |
| city_oktmo | String | Признак | Код ОКТМО города |
| air_general_level | Int | **Цель (классиф.)** | Уровень загрязнения (1–4) |
| air_standard_index | String | Признак | Вещества с СИ > 10 ПДК |
| air_repeatability | String | Признак | Повторяемость превышения ПДК |
| air_qcp | String | Признак | Вещества с концентрацией > 1 ПДК |
| air_solid_emissions | Float | Признак | Выбросы твёрдых веществ, тыс. т |
| air_so_emissions | Float | Признак | Выбросы SO₂, тыс. т |
| air_no_emissions | Float | Признак | Выбросы NO₂, тыс. т |
| air_co_emissions | Float | **Цель (регрессия)** | Выбросы CO, тыс. т |
| air_population | Float | Признак | Численность населения, тыс. чел. |
| air_stantions | String | Признак | Количество станций мониторинга |

##### [CSV-файлы](data_air_cities/data/)
##### [Подробное описание](data_air_cities/report/README.md)



***
## Лицензии
- **mobile_tariff, it_salary** — [MIT](LICENSE) (синтетические данные)
- **data_air_cities** — Open Data / CC BY (реальные данные Росгидромета, обработка проекта «Если быть точным»)