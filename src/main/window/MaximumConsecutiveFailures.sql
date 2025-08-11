-- Maximum Consecutive Failures
-- Given a table system_logs with columns log_time (timestamp) and status (either 'success' or 'failure')
-- Write a SQL query to find the maximum number of consecutive failures and the time range of this period.

WITH failure_flags AS (
  SELECT
    log_time,
    status,
    LAG(status) OVER (ORDER BY log_time) AS prev_status,
    CASE
      WHEN LAG(status) OVER (ORDER BY log_time) != 'failure' OR LAG(status) OVER (ORDER BY log_time) IS NULL THEN 1
      ELSE 0
    END AS new_streak
  FROM system_logs
),

failure_groups AS (
  SELECT
    log_time,
    status,
    SUM(new_streak) OVER (ORDER BY log_time) AS grp
  FROM failure_flags
  WHERE status = 'failure'
),

grouped_failures AS (
  SELECT
    grp,
    COUNT(*) AS failure_count,
    MIN(log_time) AS start_time,
    MAX(log_time) AS end_time
  FROM failure_groups
  GROUP BY grp
)

SELECT failure_count
FROM grouped_failures
ORDER BY failure_count DESC
LIMIT 1;
