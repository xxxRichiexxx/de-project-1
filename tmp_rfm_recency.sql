-- Создаем таблицу для первой метрики

CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

-- Расчитываем первую метрику и вставляем результат в таблицу

INSERT INTO analysis.tmp_rfm_recency
WITH count_of_records AS(
    SELECT COUNT(id)
    FROM analysis.users
),
users_with_orders AS(
    SELECT o.user_id, MAX(order_ts) as max_order_ts
    FROM analysis.orders as o
    JOIN analysis.orderstatuses as s 
        ON o.status = s.id
    WHERE s.key = 'Closed' AND EXTRACT(YEAR FROM order_ts) >= 2022
    GROUP BY o.user_id
    order by max_order_ts
),
all_users AS(
    SELECT id AS user_id, max_order_ts
    FROM analysis.users AS u
    LEFT JOIN users_with_orders AS o
    ON u.id = o.user_id
),
numered AS(
SELECT *, ROW_NUMBER() OVER (ORDER BY CASE WHEN max_order_ts IS NULL THEN 1 ELSE 2 END, max_order_ts) AS row 
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
    END Recency
FROM numered