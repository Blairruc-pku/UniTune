SELECT MIN(mv11.name) AS of_person,
       MIN(t.title) AS biography_movie
FROM mv11 AS mv11,
    aka_name AS an,
     info_type AS it,
     link_type AS lt,
     movie_link AS ml,
     person_info AS pi,
     title AS t
WHERE an.name LIKE '%a%'
  AND it.info ='mini biography'
  AND lt.link ='features'
  AND mv11.gender='m'
  AND pi.note ='Volker Boehm'
  AND t.production_year BETWEEN 1980 AND 1984
  AND mv11.id = an.person_id
  AND mv11.id = pi.person_id
  AND t.id = mv11.movie_id
  AND ml.linked_movie_id = t.id
  AND lt.id = ml.link_type_id
  AND it.id = pi.info_type_id
  AND pi.person_id = an.person_id
  AND pi.person_id = mv11.person_id
  AND an.person_id = mv11.person_id
  AND mv11.movie_id = ml.linked_movie_id;

