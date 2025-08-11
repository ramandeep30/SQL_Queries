-- Given a table orders with columns order_time (timestamp) and order_status (either 'placed', 'processed', 'shipped', 'delivered')
-- Write a SQL query to find the time it takes for each order to go from 'placed' to 'delivered'.
WITH placed_order AS (
  SELECT order_id,
         order_time AS placed_time
  FROM orders
  WHERE order_status = 'placed'
),

delivered_order AS (
  SELECT order_id,
         order_time AS delivered_time
  FROM orders
  WHERE order_status = 'delivered'
),

finalResult AS (
  SELECT
    p.order_id,
    p.placed_time,
    d.delivered_time,
    EXTRACT(EPOCH FROM d.delivered_time - p.placed_time) AS time_to_delivered_seconds
  FROM placed_order p
  JOIN delivered_order d
    ON p.order_id = d.order_id
  WHERE d.delivered_time > p.placed_time
)

SELECT order_id
FROM finalResult;
