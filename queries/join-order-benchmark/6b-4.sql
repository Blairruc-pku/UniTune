SELECT MIN(mv4.keyword) AS movie_keyword,
       MIN(n.name) AS actor_name,
       MIN(t.title) AS hero_movie
FROM mv4 AS mv4,
    cast_info AS ci,
     name AS n,
     title AS t
WHERE mv4.keyword IN ('superhero',
                    'sequel',
                    'second-part',
                    'marvel-comics',
                    'based-on-comic',
                    'tv-special',
                    'fight',
                    'violence')
  AND n.name LIKE '%Downey%Robert%'
  AND t.production_year > 2014
  AND t.id = mv4.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mv4.movie_id
  AND n.id = ci.person_id;
