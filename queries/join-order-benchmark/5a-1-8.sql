SELECT MIN(t.title) AS typical_european_movie
FROM mv1 AS mv1,
     mv8 AS mv8,
     info_type AS it,
     title AS t
WHERE mv1.note LIKE '%(theatrical)%'
  AND mv1.note LIKE '%(France)%'
  AND mv8.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German')
  AND t.production_year > 2005
  AND t.id = mv8.movie_id
  AND t.id = mv1.movie_id
  AND mv1.movie_id = mv8.movie_id
  AND it.id = mv8.info_type_id;