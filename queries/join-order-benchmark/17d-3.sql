SELECT MIN(n.name) AS member_in_charnamed_movie
FROM mv3 AS mv3,
    cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     title AS t
WHERE n.name LIKE '%Bert%'
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mv3.movie_id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mv3.movie_id
  AND mc.movie_id = mv3.movie_id;