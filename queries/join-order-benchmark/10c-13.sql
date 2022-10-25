SELECT MIN(chn.name) AS character,
       MIN(mv13.title) AS movie_with_american_producer
FROM mv13 AS mv13,
    char_name AS chn,
     cast_info AS ci,
     company_type AS ct,
     role_type AS rt
WHERE ci.note LIKE '%(producer)%'
  AND mv13.production_year > 1990
  AND mv13.id = ci.movie_id
  AND ci.movie_id = mv13.movie_id
  AND chn.id = ci.person_role_id
  AND rt.id = ci.role_id
  AND ct.id = mv13.company_type_id;
  
  