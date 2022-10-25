SELECT MIN(an.name) AS acress_pseudonym,
       MIN(mv12.title) AS japanese_anime_movie
FROM mv12 AS mv12,
    aka_name AS an,
     cast_info AS ci,
     name AS n,
     role_type AS rt
WHERE ci.note ='(voice: English version)'
  AND mv12.note LIKE '%(Japan)%'
  AND mv12.note NOT LIKE '%(USA)%'
  AND (mv12.note LIKE '%(2006)%'
       OR mv12.note LIKE '%(2007)%')
  AND n.name LIKE '%Yo%'
  AND n.name NOT LIKE '%Yu%'
  AND rt.role ='actress'
  AND mv12.production_year BETWEEN 2006 AND 2007
  AND (mv12.title LIKE 'One Piece%'
       OR mv12.title LIKE 'Dragon Ball Z%')
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = mv12.id
  AND ci.role_id = rt.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mv12.movie_id;