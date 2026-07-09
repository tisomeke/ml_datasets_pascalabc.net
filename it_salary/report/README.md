# Датасет: IT Salary (Вакансии в ИТ — предсказание зарплаты)

## Цель
Предсказать зарплату ИТ-специалиста по параметрам вакансии (регрессия).

## Предметная область
Рынок труда в ИТ-индустрии России (2025–2026 гг.).

## Версии датасета

| Версия | Файл | Строк | Столбцов | Особенности |
|--------|------|-------|----------|-------------|
| easy | `it_salary_easy.csv` | 750 | 8 | Чистая, без пропусков |
| medium | `it_salary_medium.csv` | 750 | 9 | Пропуски ~7%, DateTime |
| raw | `it_salary_raw.csv` | 750 | 10 | Пропуски ~15%, выбросы, текст |

## Признаки

| Признак | Тип | Роль | Смысл |
|---------|-----|------|-------|
| experience_years | Int | Признак | Опыт работы в годах (0–10) |
| grade | Categorical | Признак | Грейд: intern, junior, middle, senior, lead |
| specialization | Categorical | Признак | Специализация: backend, frontend, qa, devops, data_science, mobile |
| city | Categorical | Признак | Город: moscow, spb, regions (easy/medium) или конкретные города (raw) |
| work_format | Categorical | Признак | Формат: office, remote, hybrid |
| company_segment | Categorical | Признак | Сегмент: bigtech, enterprise, mid_product, outsource, smb |
| education | Categorical | Признак | Образование: higher_tech, higher_general, not_specified |
| posted_date | DateTime | Признак | Дата публикации вакансии (medium, raw) |
| description | String | Признак | Текстовое описание вакансии (только raw) |
| salary_rub | Float | **Цель** | Зарплата в рублях (net) |

## Целевая переменная
`salary_rub` — зарплата специалиста. Диапазон: ~30 000–955 000 руб. (easy/medium), до ~1 915 000 руб. (raw с выбросами).

## Особенности данных
- 750 записей, 7 признаков + целевая (easy-версия)
- Данные синтетические, основаны на реальной статистике hh.ru и Хабр Карьеры
- Задача: регрессия
- Мультипликативная модель ценообразования

## Формула

$$
\text{salary\_rub} = \text{base}(\text{spec}, \text{grade}) \times K_{\text{city}} \times K_{\text{company}} \times K_{\text{format}} \times e^{\varepsilon}, \quad \varepsilon \sim \mathcal{N}(0,\,\sigma)
$$

Коэффициенты:
- $K_{\text{city}}$: moscow=1.25, spb=1.07, regions=0.87
- $K_{\text{company}}$: bigtech=1.30, enterprise=1.10, mid_product=1.00, outsource=0.85, smb=0.80
- $K_{\text{format}}$: office=1.00, hybrid=1.05, remote=0.95
- $\sigma$: intern/junior=0.08, middle=0.12, senior/lead=0.18

## Использование

1. Откройте любой `.pas`-файл из папки `samples/` в среде PascalABC.NET.
2. Нажмите **F5** (Запуск) — программа загрузит CSV из `../data/`.
3. Для `03_baseline_model.pas` и `04_preprocessing_raw.pas` потребуется библиотека `MLABC`.

> **Примечание:** Для воспроизводимости результатов во всех примерах используется `seed := 42` при разбиении на обучающую и тестовую выборки.

## Примеры

| Файл | Что делает |
|------|------------|
| `01_load_dataset.pas` | Загружает easy-версию, выводит первые строки |
| `02_describe_dataset.pas` | Показывает типы столбцов и статистику |
| `03_baseline_model.pas` | Кодирует категориальные признаки, обучает KNN, считает метрики |
| `04_preprocessing_raw.pas` | Обрабатывает raw: заполняет пропуски, удаляет выбросы, строит модель |

## Ограничения
- Данные синтетические — не подходят для реальных бизнес-решений
- Модель ценообразования упрощённая (линейные мультипликаторы)
- Описания вакансий (raw) шаблонные
- 750 строк — достаточно для обучения, но мало для глубокого анализа
