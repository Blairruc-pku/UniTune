SELECT MIN(t.title) AS typical_european_movie
FROM mv1 AS mv1,
     info_type AS it,
     movie_info AS mi,
     title AS t
WHERE mv1.note LIKE '%(theatrical)%'
  AND mv1.note LIKE '%(France)%'
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German')
  AND t.production_year > 2005
  AND t.id = mi.movie_id
  AND t.id = mv1.movie_id
  AND mv1.movie_id = mi.movie_id
  AND it.id = mi.info_type_id;

