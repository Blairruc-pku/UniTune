SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS voiced_character,
       MIN(n.name) AS voicing_actress,
       MIN(mv13.title) AS american_movie
FROM mv13 AS mv13,
    aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     name AS n,
     role_type AS rt
WHERE ci.note = '(voice)'
  AND mv13.note LIKE '%(200%)%'
  AND (mv13.note LIKE '%(USA)%'
       OR mv13.note LIKE '%(worldwide)%')
  AND n.gender ='f'
  AND n.name LIKE '%Angel%'
  AND rt.role ='actress'
  AND mv13.production_year BETWEEN 2007 AND 2010
  AND ci.movie_id = mv13.id
  AND ci.movie_id = mv13.movie_id
  AND ci.role_id = rt.id
  AND n.id = ci.person_id
  AND chn.id = ci.person_role_id
  AND an.person_id = n.id
  AND an.person_id = ci.person_id;