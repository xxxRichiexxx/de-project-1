# Выполнение проекта:
### 1) Определяем метрики
* user_id
* recency (число от 1 до 5). 
Фактор Recency измеряется по последнему заказу. Необходимо распределить клиентов по шкале от одного до пяти, где значение 1 получат те, кто либо вообще не делал заказов, либо делал их очень давно, а 5 — те, кто заказывал относительно недавно.

        > Для расчета потребуются пользователи, заказы, статусы.

* frequency (число от 1 до 5)
Фактор Frequency оценивается по количеству заказов. Необходимо распределить клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшим количеством заказов, а 5 — с наибольшим.

        > Для расчета потребуются пользователи, заказы, статусы.

* monetary_value (число от 1 до 5)
 Фактор Monetary Value оценивается по потраченной сумме. Необходимо распределить клиентов по шкале от одного до пяти, где значение 1 получат клиенты с наименьшей суммой, а 5 — с наибольшей.
	
        > Для расчета потребуются пользователи, заказы, статусы.

### 2) Проверяем доступность источников

    SELECT * from production.users limit 50

|	|id	integer|name character varying	|login character varying        |
|---|-------   |-------------------     |-------------------------------|
|1	|0	       |potap50	                |Степан  Герасимович Кузнецов   |
|2	|1	       |kliment56	            |Сократ  Харлампович Филатов    |
|3	|2	       |komissarovamarija	    |Веселов Никифор     Иосифович  |
|4	|3	       |seleznevprohor	        |Матвеев Прокофий    Ааронович  |
|5	|4	       |egorkudrjashov	        |Марк    Жанович     Кузьмин    |

	

    SELECT * from production.orders limit 50

|   | order_id | order_ts                                                             | user_id | bonus_payment | payment    | cost       | bonus_grant | status  |
|---|----------|----------------------------------------------------------------------|---------|---------------|------------|------------|-------------|---------|
|   | integer  | timestamp without time zone                                          | integer | numeric       | numeric    | numeric    | numeric     | integer |
| 1 | 3562553  | Fri Mar 04 2022 20:53:19 GMT+0000 (Всемирное координированное время) | 875     | 0.00000       | 4440.00000 | 4440.00000 | 44.40000    | 5       |
| 2 | 9519451  | Wed Mar 02 2022 00:24:50 GMT+0000 (Всемирное координированное время) | 576     | 0.00000       | 3000.00000 | 3000.00000 | 30.00000    | 5       |
| 3 | 2343007  | Mon Mar 07 2022 07:31:25 GMT+0000 (Всемирное координированное время) | 181     | 0.00000       | 1620.00000 | 1620.00000 | 16.20000    | 5       |
| 4 | 5205491  | Sat Mar 12 2022 10:10:52 GMT+0000 (Всемирное координированное время) | 957     | 0.00000       | 4200.00000 | 4200.00000 | 42.00000    | 4       |
| 5 | 2071767  | Sun Feb 20 2022 06:42:26 GMT+0000 (Всемирное координированное время) | 539     | 0.00000       | 4620.00000 | 4620.00000 | 46.20000    | 4       |


    SELECT * from production.orderstatuses limit 50

|   | id      | key               |
|---|---------|-------------------|
|   | integer | character varying |
| 1 | 1       | Open              |
| 2 | 2       | Cooking           |
| 3 | 3       | Delivering        |
| 4 | 4       | Closed            |
| 5 | 5       | Cancelled         |

    SELECT * from production.orderstatuslog limit 50

|   | id      | order_id | status_id | dttm                                                                 |
|---|---------|----------|-----------|----------------------------------------------------------------------|
|   | integer | integer  | integer   | timestamp without time zone                                          |
| 1 | 1       | 3562553  | 5         | Fri Mar 04 2022 20:53:19 GMT+0000 (Всемирное координированное время) |
| 2 | 2       | 3562553  | 1         | Fri Mar 04 2022 20:36:10 GMT+0000 (Всемирное координированное время) |
| 3 | 3       | 9519451  | 5         | Wed Mar 02 2022 00:24:50 GMT+0000 (Всемирное координированное время) |
| 4 | 4       | 9519451  | 1         | Tue Mar 01 2022 23:28:33 GMT+0000 (Всемирное координированное время) |

Для расчета метрики user_id будем использовать поле users.id
Для расчета метрики recency будем использовать поля orders.users_id, orders.order_ts, orders.status.
Для расчета метрики frequency будем использовать поля orders.users_id, orders.order_ts, orders.order_id, orders.status.
Для расчета метрики monetary_value будем использовать поля orders.users_id, orders.order_ts, orders.cost, orders.status.
Проведем проверку качества данных в данных полях.

### 3) Проверка качества данных

    см data_quality.md

### 5) Подготовка витрины данных
В задании требуется обращаться только к объектам из схемы analysis при расчёте витрины. Чтобы не дублировать данные, которые находятся в этой же базе, делаем представления:

    views.sql

Создаем витрину данных:
    
    datamart_ddl.sql

### 6) Наполнение витрины
Расчитываем витрину поэтапно.

Расчет первой метрики:
    
    tmp_rfm_recency.sql

проверка:

    SELECT recency, COUNT(user_id), MAX(user_id)
    FROM analysis.tmp_rfm_recency
    GROUP BY Recency
    ORDER BY recency

|   | recency | count  | max     |
|---|---------|--------|---------|
|   | integer | bigint | integer |
| 1 | 1       | 200    | 999     |
| 2 | 2       | 200    | 990     |
| 3 | 3       | 200    | 992     |
| 4 | 4       | 200    | 996     |
| 5 | 5       | 200    | 997     |

Расчет второй метрики:

    tmp_rfm_frequency.sql

проверка:

    SELECT frequency, COUNT(user_id), MAX(user_id)
    FROM analysis.tmp_rfm_frequency
    GROUP BY frequency
    ORDER BY frequency

    	
|   | frequency | count  | max     |
|---|-----------|--------|---------|
|   | integer   | bigint | integer |
| 1 | 1         | 200    | 998     |
| 2 | 2         | 200    | 999     |
| 3 | 3         | 200    | 987     |
| 4 | 4         | 200    | 995     |
| 5 | 5         | 200    | 997     |

Расчет третьей метрики:

    tmp_rfm_monetary_value.sql
    
проверка:

    SELECT monetary_value, COUNT(user_id), MAX(user_id)
    FROM analysis.tmp_rfm_monetary_value
    GROUP BY monetary_value
    ORDER BY monetary_value

|   | monetary_value | count  | max     |
|---|----------------|--------|---------|
|   | integer        | bigint | integer |
| 1 | 1              | 200    | 989     |
| 2 | 2              | 200    | 998     |
| 3 | 3              | 200    | 999     |
| 4 | 4              | 200    | 982     |
| 5 | 5              | 200    | 997     |

На основе данных, подготовленных в таблицах analysis.tmp_rfm_recency, analysis.tmp_rfm_frequency и analysis.tmp_rfm_monetary_value, заполняем витрину analysis.dm_rfm_segments.

    datamart_query.sql

проверяем:

    SELECT * FROM analysis.dm_rfm_segments
    ORDER BY user_id
    LIMIT 10

    	
|    | user_id | recency | frequency | monetary_value |
|----|---------|---------|-----------|----------------|
|    | integer | integer | integer   | integer        |
| 1  | 0       | 1       | 3         | 4              |
| 2  | 1       | 4       | 3         | 3              |
| 3  | 2       | 2       | 3         | 5              |
| 4  | 3       | 2       | 3         | 3              |
| 5  | 4       | 4       | 3         | 3              |
| 6  | 5       | 5       | 5         | 5              |
| 7  | 6       | 1       | 3         | 5              |
| 8  | 7       | 4       | 2         | 2              |
| 9  | 8       | 1       | 1         | 3              |
| 10 | 9       | 1       | 3         | 2              |  


### 7) Доработка представлений
В источнике production.orders пропало поле status, но появилась таблица production.orderstatuslog.
Переписываем представление analysis.orders таким образом, чтобы там сохранилось поле status:
    
    orders_view.sql