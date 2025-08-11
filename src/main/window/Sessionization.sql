-- Given a table user_activity with columns activity_time (timestamp) and user_id
-- write a SQL query to identify user sessions where a session is defined as a sequence of activities by the same user
-- with no more than 5 minutes between any two consecutive activities.


WITH activity_with_lag AS (
  SELECT
    user_id,
    activity_time,
    LAG(activity_time) OVER (PARTITION BY user_id ORDER BY activity_time) AS previous_activity_time
  FROM user_activity
),

sessions AS (
  SELECT
    user_id,
    activity_time,
    previous_activity_time,
    CASE
      WHEN previous_activity_time IS NULL OR EXTRACT(EPOCH FROM (activity_time - previous_activity_time)) > 300 THEN 1
      ELSE 0
    END AS new_session
  FROM activity_with_lag
),

grouped_sessions AS (
  SELECT
    user_id,
    activity_time,
    SUM(new_session) OVER (PARTITION BY user_id ORDER BY activity_time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS session_id
  FROM sessions
)

SELECT
  user_id,
  activity_time,
  session_id
FROM grouped_sessions
ORDER BY user_id, activity_time;
