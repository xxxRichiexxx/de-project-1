# Проверка качества данных:

Проведем проверку качества данных в следующих полях users.id, orders.users_id, orders.order_ts, orders.status, orders.order_id, orders.cost:

    SELECT constraint_name 
        FROM information_schema.REFERENTIAL_CONSTRAINTS
		
|  |   | constraint_name               |
|--|---|-------------------------------|
|  |   | name                          |
|  | 1 | orderitems_product_id_fkey    |
|  | 2 | orderitems_order_id_fkey      |
|  | 3 | orderstatuslog_order_id_fkey  |
|  | 4 | orderstatuslog_status_id_fkey |

    SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE table_name IN ('users', 'orders')
    ORDER BY table_name

|    | table_name | constraint_type   | constraint_name        |
|----|------------|-------------------|------------------------|
|    | name       | character varying | name                   |
| 1  | orders     | CHECK             | 16390_16415_8_not_null |
| 2  | orders     | CHECK             | orders_check           |
| 3  | orders     | PRIMARY KEY       | orders_pkey            |
| 4  | orders     | CHECK             | 16390_16415_5_not_null |
| 5  | orders     | CHECK             | 16390_16415_6_not_null |
| 6  | orders     | CHECK             | 16390_16415_7_not_null |
| 7  | orders     | CHECK             | 16390_16415_1_not_null |
| 8  | orders     | CHECK             | 16390_16415_2_not_null |
| 9  | orders     | CHECK             | 16390_16415_3_not_null |
| 10 | orders     | CHECK             | 16390_16415_4_not_null |
| 11 | users      | CHECK             | 16390_16407_1_not_null |
| 12 | users      | CHECK             | 16390_16407_3_not_null |
| 13 | users      | PRIMARY KEY       | users_pkey             |


Проведем дополнительную проверку целевых полей.

В таблице production.orders нас интересуют поля order_id, order_ts, user_id, cost, status (данные поля участвуют в расчетах):

    SELECT COUNT(*) AS "Общее кол-во строк",
        COUNT(order_id) AS "Количество заполненных строк order_id",
        COUNT(DISTINCT order_id) AS "Количество уникальных order_id",
        COUNT(user_id) AS "Количество заполненных строк user_id",
        COUNT(order_ts) AS "Количество заполненных строк order_ts",
        COUNT(cost) AS "Количество заполненных строк cost",
        COUNT(status) AS "Количество заполненных строк status"
    FROM production.orders
	
|  |   | Общее кол-во строк | Количество заполненных строк order_id | Количество уникальных order_id | Количество заполненных строк user_id | Количество заполненных строк order_ts | Количество заполненных строк cost | Количество заполненных строк status |
|--|---|--------------------|---------------------------------------|--------------------------------|--------------------------------------|---------------------------------------|-----------------------------------|-------------------------------------|
|  |   | bigint             | bigint                                | bigint                         | bigint                               | bigint                                | bigint                            | bigint                              |
|  | 1 | 10000              | 10000                                 | 10000                          | 10000                                | 10000                                 | 10000                             | 10000                               |


В таблице production.users нас интересует поле id (данное поле участвуют в расчетах):

    SELECT COUNT(*) AS "Общее кол-во записей",
	       COUNT(id) AS "Количество заполненных id",
	       COUNT(DISTINCT id) AS "Кол-во уникальных id"
	FROM production.users
	
|  |   | Общее кол-во записей | Количество заполненных id | Кол-во уникальных id |
|--|---|----------------------|---------------------------|----------------------|
|  |   | bigint               | bigint                    | bigint               |
|  | 1 | 1000                 | 1000                      | 1000                 |

Проверим таблицу production.orderstatuslog. Нас интересуют поля order_id, status_id, dttm:

    SELECT COUNT(*) AS "Общее кол-во записей",
           COUNT(order_id) AS "Количество заполненных order_id",
           COUNT(status_id) AS "Количество заполненных status_id", 
           COUNT(dttm) AS "Количество заполненных dttm"
    FROM production.orderstatuslog
	
|  |   | Общее кол-во записей | Количество заполненных order_id | Количество заполненных status_id | Количество заполненных dttm |
|--|---|----------------------|---------------------------------|----------------------------------|-----------------------------|
|  |   | bigint               | bigint                          | bigint                           | bigint                      |
|  | 1 | 29982                | 29982                           | 29982                            | 29982                       |

Дублей нет, пропусков нет, все поля заполнены, все типы данных соответствующие.