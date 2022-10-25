SELECT MIN(an.name) AS cool_actor_pseudonym,
       MIN(mv28.title) AS series_named_after_char
FROM mv28 AS mv28,
    aka_name AS an,
     cast_info AS ci,
     company_name AS cn,
     keyword AS k,
     movie_companies AS mc,
     movie_keyword AS mk,
     name AS n
WHERE cn.country_code ='[us]'
  AND k.keyword ='character-name-in-title'
  AND an.person_id = n.id
  AND n.id = ci.person_id
  AND ci.movie_id = mv28.id
  AND mv28.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mv28.id = mc.movie_id
  AND mc.company_id = cn.id
  AND an.person_id = ci.person_id
  AND ci.movie_id = mc.movie_id
  AND ci.movie_id = mk.movie_id
  AND mc.movie_id = mk.movie_id;