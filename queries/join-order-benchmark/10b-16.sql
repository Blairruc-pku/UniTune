SELECT MIN(chn.name) AS character_name,
       MIN(mv16.title) AS russian_mov_with_actor_producer
FROM mv16 AS mv16,
     char_name AS chn,
     company_type AS ct
WHERE mv16.production_year > 2010
  AND chn.id = mv16.person_role_id
  AND ct.id = mv16.company_type_id;