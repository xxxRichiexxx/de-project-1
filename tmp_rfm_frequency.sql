-- Создаем таблицу для второй метрики

CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

-- Расчитываем вторую метрику и вставляем результат в таблицу

INSERT INTO analysis.tmp_rfm_frequency
WITH count_of_records AS(
    SELECT COUNT(id)
    FROM analysis.users
),
users_with_orders AS(
    SELECT o.user_id, COUNT(order_id) as orders_count
    FROM analysis.orders as o
    JOIN analysis.orderstatuses as s 
        ON o.status = s.id
    WHERE s.key = 'Closed' AND EXTRACT(YEAR FROM order_ts) >= 2022
    GROUP BY o.user_id
    order by orders_count
),
all_users AS(
    SELECT id AS user_id, orders_count
    FROM analysis.users AS u
    LEFT JOIN users_with_orders AS o
    ON u.id = o.user_id
),
numered AS(
SELECT *, ROW_NUMBER() OVER (ORDER BY CASE WHEN orders_count IS NULL THEN 1 ELSE 2 END, orders_count) AS row 
FROM all_users
order by row
)
SELECT user_id, CASE
    WHEN row BETWEEN 1 AND (SELECT * FROM count_of_records)/5
    THEN 1
    WHEN row BETWEEN (SELECT * FROM count_of_records)/5 +1 AND 2*(SELECT * FROM count_of_records)/5
    THEN 2
    WHEN row BETWEEN 2*(SELECT * FROM count_of_records)/5 +1 AND 3*(SELECT * FROM count_of_records)/5
    THEN 3
    WHEN row BETWEEN 3*(SELECT * FROM count_of_records)/5 +1 AND 4*(SELECT * FROM count_of_records)/5
    THEN 4
    ELSE 5
    END frequency
FROM numered