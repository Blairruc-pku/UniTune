SELECT MIN(an1.name) AS costume_designer_pseudo,
       MIN(mv13.title) AS movie_with_costumes
FROM mv13 AS mv13,
    aka_name AS an1,
     cast_info AS ci,
     name AS n1,
     role_type AS rt
WHERE rt.role ='costume designer'
  AND an1.person_id = n1.id
  AND n1.id = ci.person_id
  AND ci.movie_id = mv13.id
  AND ci.role_id = rt.id
  AND an1.person_id = ci.person_id
  AND ci.movie_id = mv13.movie_id;