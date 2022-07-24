-- Вариант 1
-- Hash Join  (cost=2488.37..2758.87 rows=150 width=43)
CREATE OR REPLACE VIEW analysis.orders AS
WITH sq1 AS(
SELECT order_id, status_id, dttm, MAX(dttm) OVER(PARTITION BY order_id) AS max_dttm  
FROM  production.orderstatuslog AS l
),
sq2 AS(
SELECT order_id, status_id
FROM sq1
WHERE dttm = max_dttm
)
SELECT o.*, sq2.status_id AS status
FROM production.orders AS o
JOIN sq2 USING(order_id);

-- Вариант 2
-- Nested Loop  (cost=991.01..1639.29 rows=1 width=43)
CREATE OR REPLACE VIEW analysis.orders AS
WITH sq AS(
SELECT order_id, MAX(dttm) AS max_dttm  
FROM  production.orderstatuslog
GROUP BY order_id
)
SELECT o.*, l.status_id AS status
FROM production.orders AS o
JOIN sq USING (order_id)
JOIN production.orderstatuslog AS l
    ON sq.order_id = l.order_id AND sq.max_dttm = l.dttm;