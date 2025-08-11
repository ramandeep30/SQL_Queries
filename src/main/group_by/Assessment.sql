
-- On an online recruiting platform, each recruiting company can make a request for their candidates to complete a
-- personalized skill assessment. The assessment can contain tasks in three categories: SQL, Algo and BugFixing.
-- Following the assessment, the company receives a report containing, for each candidate,
-- their declared years of experience (an integer between 0 and 100) and their score in each category.
-- The score is the number of points from 0 to 100, or NULL, which means there was no task in this category.

--You are given a table, assessments, with the following structure:
create table assessments (
 id integer not null,
 experience integer not null,
 sq- integer,
 algo integer,
 bug_fixing integer,
 unique (id)
) ;

-- Your task is to write an SQL query that, for each different length of experience,
-- counts the number of candidates with precisely that amount of experience and how many of them got a perfect score
-- in each category in which they were requested to solve tasks (so a NULL score is here treated as a perfect score).
-- Your query should return a table containing the following columns:
-- exp (each candidate's years of experience),
-- max (number of assessments achieving the maximum score),
-- count (total number of assessments). Rows should be ordered by decreasing exp.

  SELECT
      experience AS exp,
      COUNT(CASE
                WHEN (sq = 100 OR sq IS NULL) AND (algo = 100 OR algo IS NULL) AND (bug_fixing = 100 OR bug_fixing IS NULL) THEN 1
            END)
      AS max,
      count(*) AS count
  FROM
      assessments
  GROUP BY
      experience
  ORDER BY
      exp DESC;


select experience as exp, count(case when (sql = 100 OR sql IS NULL) AND (bug_fixing=100 OR bug_fixing IS NULL) AND (algo=100 OR algo IS NULL) THEN 1 END) as max,
count(*) from assessments group by exp order by exp desc;
