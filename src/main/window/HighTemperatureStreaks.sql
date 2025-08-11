-- Given a table temperature_readings with columns reading_time (timestamp) and temperature.
-- Write a SQL query to find the periods where the temperature was continuously above 30 degrees for at least 2 consecutive readings.

WITH with_flags AS (
  SELECT
    reading_time,
    temperature,
    CASE
      WHEN temperature > 30 THEN 1 ELSE 0
    END AS is_hot
  FROM temperature_readings
),
with_groups AS (
  SELECT *,
         SUM(CASE
               WHEN is_hot = 0 THEN 1
               ELSE 0
             END) OVER (ORDER BY reading_time ROWS UNBOUNDED PRECEDING) AS group_id
  FROM with_flags
),
filtered_groups AS (
  SELECT group_id
  FROM with_groups
  WHERE is_hot = 1
  GROUP BY group_id
  HAVING COUNT(*) >= 2
)
SELECT w.reading_time, w.temperature
FROM with_groups w
JOIN filtered_groups f ON w.group_id = f.group_id
WHERE w.is_hot = 1
ORDER BY w.reading_time;
