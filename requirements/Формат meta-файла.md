Файл метаинформации (`.meta`) представляет собой простой текстовый формат «ключ — значение», который необходим для каждого CSV-файла.

### Структура мета-файла

Ниже приведены основные поля, которые должны присутствовать в мета-файле:

* **name**: Название датасета.
* **variant**: Версия датасета (например, `medium`).
* **rows**: Количество строк.
* **columns**: Количество столбцов.
* **version**: Версия (например, `1.0`).
* **features**: Перечисление всех признаков через запятую.
* **target**: Указание целевой переменной.
* **description.en / description.ru**: Описание датасета на английском и русском языках.
* **source**: Информация об источнике данных.
* **license**: Условия лицензирования (например, `educational`).
* **missing**: Наличие пропусков (`yes`/`no`) и их обозначение (например, `NA`).
* **feature.[name]**: Определение типа каждого признака (например, `float`, `int`, `categorical`, `bool`, `DateTime`).
* **feature.[name].ru / feature.[name].en**: Названия признаков на русском и английском языках.

### Пример заполнения

```text
name ShopSalesRU
variant medium
rows 3000
columns 9
version 1.0
features sale_date,city,category,brand,price,discount,quantity,is_weekend
target revenue
description.ru Учебный датасет продаж магазина...
description.en Educational shop sales dataset...
source synthetic dataset based on typical retail scenarios
license educational
missing yes
missing values NA
feature.sale_date DateTime
feature.price float
feature.city.ru город
feature.price.ru цена товара

```

Важно, чтобы мета-файл полностью соответствовал реальному содержанию CSV-файла и точно отражал структуру данных.