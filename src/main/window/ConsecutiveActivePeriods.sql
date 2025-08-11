-- Consecutive Active Periods
-- Given a table events with columns event_time (timestamp) and status (either 'active' or 'inactive')
-- Write a SQL query to find the start and end times of consecutive active periods and their durations.

WITH event_markers AS (
  SELECT
    event_time,
    status,
    LAG(status) OVER (ORDER BY event_time) AS previous_state,
    CASE
      WHEN status = 'active' AND
           (LAG(status) OVER (ORDER BY event_time) = 'inactive'
            OR LAG(status) OVER (ORDER BY event_time) IS NULL)
      THEN 1
      ELSE 0
    END AS new_period
  FROM events
),

grouped_events AS (
  SELECT
    event_time,
    status,
    SUM(new_period) OVER (ORDER BY event_time) AS period_group
  FROM event_markers
  WHERE status = 'active'
)

SELECT
  MIN(event_time) AS start_time,
  MAX(event_time) AS end_time,
  EXTRACT(EPOCH FROM MAX(event_time) - MIN(event_time)) AS duration_seconds
FROM grouped_events
GROUP BY period_group
ORDER BY start_time;
