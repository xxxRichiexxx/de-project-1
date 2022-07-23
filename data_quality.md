SELECT constraint_name 
    FROM information_schema.REFERENTIAL_CONSTRAINTS
		
|  |   | constraint_name               |
|--|---|-------------------------------|
|  |   | name                          |
|  | 1 | orderitems_product_id_fkey    |
|  | 2 | orderitems_order_id_fkey      |
|  | 3 | orderstatuslog_order_id_fkey  |
|  | 4 | orderstatuslog_status_id_fkey |

Т.к не на всех полях, участвующих в расчетах, наложены ограничения, то проведем дополнительную проверку качества данных.

В таблице production.orders нас интересуют поля order_id, user_id, cost, status (данные поля участвуют в расчетах):

    SELECT COUNT(*) AS "Общее кол-во строк",
	       COUNT(order_id) AS "Количество заполненных строк order_id",
	       COUNT(DISTINCT order_id) AS "Количество уникальных order_id",
	       COUNT(user_id) AS "Количество заполненных строк user_id",
           COUNT(cost) AS "Количество заполненных строк cost",
           COUNT(status) AS "Количество заполненных строк status"
	FROM production.orders
	
|  |   | Общее кол-во строк | Количество заполненных строк order_id | Количество уникальных order_id | Количество заполненных строк user_id | Количество заполненных строк cost | Количество заполненных строк status |
|--|---|--------------------|---------------------------------------|--------------------------------|--------------------------------------|-----------------------------------|-------------------------------------|
|  |   | bigint             | bigint                                | bigint                         | bigint                               | bigint                            | bigint                              |
|  | 1 | 10000              | 10000                                 | 10000                          | 10000                                | 10000                             | 10000                               |


В таблице production.orderstatuslog нас интересуют поля order_id, status_id, dttm (данные поля участвуют в расчетах):

    SELECT COUNT(*) AS "Общее кол-во записей",
           COUNT(order_id) AS "Количество заполненных order_id",
           COUNT(status_id) AS "Количество заполненных status_id", 
           COUNT(dttm) AS "Количество заполненных dttm"
    FROM production.orderstatuslog
	
|  |   | Общее кол-во записей | Количество заполненных order_id | Количество заполненных status_id | Количество заполненных dttm |
|--|---|----------------------|---------------------------------|----------------------------------|-----------------------------|
|  |   | bigint               | bigint                          | bigint                           | bigint                      |
|  | 1 | 29982                | 29982                           | 29982                            | 29982                       |

В таблице production.users нас интересует поле id (данное поле участвуют в расчетах):

    SELECT COUNT(*) AS "Общее кол-во записей",
	       COUNT(id) AS "Количество заполненных id",
	       COUNT(DISTINCT id) AS "Кол-во уникальных id"
	FROM production.users
	
|  |   | Общее кол-во записей | Количество заполненных id | Кол-во уникальных id |
|--|---|----------------------|---------------------------|----------------------|
|  |   | bigint               | bigint                    | bigint               |
|  | 1 | 1000                 | 1000                      | 1000                 |

Дублей нет, пропусков нет, все поля заполнены, все типы данных соответствующие.