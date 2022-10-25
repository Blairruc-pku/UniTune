SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS character_name,
       MIN(mv13.title) AS movie
FROM mv13 AS mv13,
    aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     name AS n,
     role_type AS rt
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND mv13.note IS NOT NULL
  AND (mv13.note LIKE '%(USA)%'
       OR mv13.note LIKE '%(worldwide)%')
  AND n.gender ='f'
  AND n.name LIKE '%Ang%'
  AND rt.role ='actress'
  AND mv13.production_year BETWEEN 2005 AND 2015
  AND ci.movie_id = mv13.id
  AND ci.movie_id = mv13.movie_id
  AND ci.role_id = rt.id
  AND n.id = ci.person_id
  AND chn.id = ci.person_role_id
  AND an.person_id = n.id
  AND an.person_id = ci.person_id;