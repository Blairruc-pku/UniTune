SELECT MIN(an1.name) AS actress_pseudonym,
       MIN(mv12.title) AS japanese_movie_dubbed
FROM mv12 AS mv12,
    aka_name AS an1,
     cast_info AS ci,
     name AS n1,
     role_type AS rt
WHERE ci.note ='(voice: English version)'
  AND mv12.note LIKE '%(Japan)%'
  AND mv12.note NOT LIKE '%(USA)%'
  AND n1.name LIKE '%Yo%'
  AND n1.name NOT LIKE '%Yu%'
  AND rt.role ='actress'
  AND an1.person_id = n1.id
  AND n1.id = ci.person_id
  AND ci.movie_id = mv12.id
  AND ci.role_id = rt.id
  AND an1.person_id = ci.person_id
  AND ci.movie_id = mv12.movie_id;

