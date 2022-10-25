SELECT MIN(t.title) AS movie_title
FROM mv3 AS mv3,
    company_name AS cn,
     movie_companies AS mc,
     title AS t
WHERE cn.country_code ='[sm]'
  AND cn.id = mc.company_id
  AND mc.movie_id = t.id
  AND t.id = mv3.movie_id
  AND mc.movie_id = mv3.movie_id;