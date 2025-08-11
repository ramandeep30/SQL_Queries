-- Consecutive Active Periods
-- Given a table events with columns event_time (timestamp) and status (either 'active' or 'inactive')
-- Write a SQL query to find the start and end times of consecutive active periods and their durations.

WITH C1 AS(
select event_time, status, lag(status) OVER (ORDER BY event_time) as previous_status from table1
),

WITH C2 AS(
select event_time, status, previous_status,
 CASE
   WHEN status = 'Active' AND previous_status = 'Inactive' OR previous_status IS NULL THEN 1 ELSE 0
  END AS new_period
 from C1
),

WITH C3 AS(
select event_time, status,
sum(new_period) over (ORDER BY event_time) as flag
from c2
WHERE status = 'active'
),

select
min(event_time) as start_time,
max(event_time) as event_time,
EXTRACT(EPOCH FROM max(event_time) - min(event_time)) AS duration_time
from C3
group by flag;