SELECT MIN(t.title) AS american_vhs_movie
FROM mv1 AS mv1,
     info_type AS it,
     movie_info AS mi,
     title AS t
WHERE mv1.note LIKE '%(VHS)%'
  AND mv1.note LIKE '%(USA)%'
  AND mv1.note LIKE '%(1994)%'
  AND mi.info IN ('USA',
                  'America')
  AND t.production_year > 2010
  AND t.id = mi.movie_id
  AND t.id = mv1.movie_id
  AND mv1.movie_id = mi.movie_id
  AND it.id = mi.info_type_id;
