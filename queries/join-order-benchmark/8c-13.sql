SELECT MIN(a1.name) AS writer_pseudo_name,
       MIN(mv13.title) AS movie_title
FROM mv13 AS mv13,
    aka_name AS a1,
     cast_info AS ci,
     name AS n1,
     role_type AS rt
WHERE rt.role ='writer'
  AND a1.person_id = n1.id
  AND n1.id = ci.person_id
  AND ci.movie_id = mv13.id
  AND ci.role_id = rt.id
  AND a1.person_id = ci.person_id
  AND ci.movie_id = mv13.movie_id;