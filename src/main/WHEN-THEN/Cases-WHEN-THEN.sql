--  Categorize Sales Performance
select id, sales,
  case
    when sales > 1000 then 'High'
    when sales < 500 and sales > 300 then 'Medium'
    else 'LOW'
  end as performance
from Sales_Data;

-- Count females and males in department
select department,
  sum(case when gender = 'Male' then 1 else 0) as male_count,
  sum(case when gender = 'Female' then 1 else 0) as female_count
 from Employees
 group by department;
