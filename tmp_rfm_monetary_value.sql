-- Создаем таблицу для третьей метрики

CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

-- Расчитываем третью метрику и вставляем результат в таблицу

INSERT INTO analysis.tmp_rfm_monetary_value
WITH status AS(
    SELECT id
    FROM analysis.orderstatuses
    WHERE key = 'Closed'
)
SELECT
    u.id AS user_id,
    NTILE(5) OVER(ORDER BY SUM(o.cost) NULLS FIRST) AS monetary_value
FROM analysis.users AS u
LEFT JOIN analysis.orders AS o
    ON u.id = o.user_id
    AND o.status = (SELECT * FROM status)
    AND EXTRACT(YEAR FROM o.order_ts) >= 2022
GROUP BY u.id;