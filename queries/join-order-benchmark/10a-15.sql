SELECT MIN(chn.name) AS uncredited_voiced_character,
       MIN(mv15.title) AS russian_movie
FROM mv15 AS mv15,
    char_name AS chn,
     cast_info AS ci,
     company_type AS ct,
     role_type AS rt
WHERE ci.note LIKE '%(voice)%'
  AND ci.note LIKE '%(uncredited)%'
  AND rt.role = 'actor'
  AND mv15.production_year > 2005
  AND mv15.id = ci.movie_id
  AND ci.movie_id = mv15.movie_id
  AND chn.id = ci.person_role_id
  AND rt.id = ci.role_id
  AND ct.id = mv15.company_type_id;

