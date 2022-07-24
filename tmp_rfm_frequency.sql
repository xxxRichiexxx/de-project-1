-- Создаем таблицу для второй метрики

CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

-- Расчитываем вторую метрику и вставляем результат в таблицу

INSERT INTO analysis.tmp_rfm_frequency
WITH status AS(
    SELECT id
    FROM analysis.orderstatuses
    WHERE key = 'Closed'
)
SELECT
    u.id AS user_id,
    NTILE(5) OVER(ORDER BY COUNT(o.order_id) NULLS FIRST) AS frequency
FROM analysis.users AS u
LEFT JOIN analysis.orders AS o
    ON u.id = o.user_id
    AND o.status = (SELECT * FROM status)
    AND EXTRACT(YEAR FROM o.order_ts) >= 2022
GROUP BY u.id;