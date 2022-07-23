-- Вариант 1
-- Hash Join  (cost=344.00..992.23 rows=1 width=43)
SELECT o.*, l.status_id AS status
FROM analysis.orders AS o
JOIN analysis.orderstatuslog AS l USING(order_id)
WHERE o.order_ts = l.dttm

-- Вариант 2
-- Hash Join  (cost=2488.37..2758.87 rows=150 width=43)
WITH sq1 AS(
SELECT order_id, status_id, dttm, MAX(dttm) OVER(PARTITION BY order_id) AS max_dttm  
FROM  analysis.orderstatuslog AS l
),
sq2 AS(
SELECT order_id, status_id
FROM sq1
WHERE dttm = max_dttm
)
SELECT o.*, sq2.status_id AS status
FROM analysis.orders AS o
JOIN sq2 USING(order_id)

-- Вариант 3
-- Nested Loop  (cost=991.01..1639.29 rows=1 width=43)

WITH sq1 AS(
SELECT order_id, MAX(dttm) AS max_dttm  
FROM  analysis.orderstatuslog
GROUP BY order_id
)
SELECT o.*, l.status_id AS status
FROM analysis.orders AS o
JOIN sq1 USING (order_id)
JOIN analysis.orderstatuslog AS l
    ON sq1.order_id = l.order_id AND sq1.max_dttm = l.dttm