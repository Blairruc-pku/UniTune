SELECT MIN(mi_idx.info) AS rating,
       MIN(t.title) AS north_european_dark_production
FROM mv8 AS mv8,
    info_type AS it1,
     info_type AS it2,
     keyword AS k,
     kind_type AS kt,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     title AS t
WHERE it1.info = 'countries'
  AND it2.info = 'rating'
  AND k.keyword IS NOT NULL
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mv8.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Danish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND mi_idx.info < '8.5'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mv8.movie_id
  AND t.id = mk.movie_id
  AND t.id = mi_idx.movie_id
  AND mk.movie_id = mv8.movie_id
  AND mk.movie_id = mi_idx.movie_id
  AND mv8.movie_id = mi_idx.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mv8.info_type_id
  AND it2.id = mi_idx.info_type_id;

