SELECT MIN(t.title) AS american_vhs_movie
FROM mv1 AS mv1,
     mv8 AS mv8,
     info_type AS it,
     title AS t
WHERE mv1.note LIKE '%(VHS)%'
  AND mv1.note LIKE '%(USA)%'
  AND mv1.note LIKE '%(1994)%'
  AND mv8.info IN ('USA',
                  'America')
  AND t.production_year > 2010
  AND t.id = mv8.movie_id
  AND t.id = mv1.movie_id
  AND mv1.movie_id = mv8.movie_id
  AND it.id = mv8.info_type_id;
