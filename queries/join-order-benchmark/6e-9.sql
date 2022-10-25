SELECT MIN(mv9.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(mv9.title) AS marvel_movie
FROM mv9 AS mv9,
    cast_info AS ci,
     name AS n
WHERE n.name LIKE '%Downey%Robert%'
  AND mv9.production_year > 2000
  AND mv9.id = ci.movie_id
  AND n.id = ci.person_id;
