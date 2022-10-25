SELECT MIN(mv10.name) AS of_person,
       MIN(t.title) AS biography_movie
FROM mv10 AS mv10,
    aka_name AS an,
     info_type AS it,
     link_type AS lt,
     movie_link AS ml,
     person_info AS pi,
     title AS t
WHERE an.name LIKE '%a%'
  AND it.info ='mini biography'
  AND lt.link ='features'
  AND (mv10.gender='m'
       OR (mv10.gender = 'f'
           AND mv10.name LIKE 'B%'))
  AND pi.note ='Volker Boehm'
  AND t.production_year BETWEEN 1980 AND 1995
  AND mv10.id = an.person_id
  AND mv10.id = pi.person_id
  AND t.id = mv10.movie_id
  AND ml.linked_movie_id = t.id
  AND lt.id = ml.link_type_id
  AND it.id = pi.info_type_id
  AND pi.person_id = an.person_id
  AND pi.person_id = mv10.person_id
  AND an.person_id = mv10.person_id
  AND mv10.movie_id = ml.linked_movie_id;