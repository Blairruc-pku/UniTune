SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(t.title) AS series_named_after_char
FROM mv3 AS mv3,
    aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     title AS t
WHERE cn.country_code ='[us]'
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = t.id
  AND t.id = mv3.movie_id
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mv3.movie_id
  AND mc.movie_id = mv3.movie_id;