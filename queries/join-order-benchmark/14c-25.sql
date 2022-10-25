SELECT MIN(mv25.minfo) AS rating,
       MIN(t.title) AS north_european_dark_production
FROM mv25 AS mv25,
    info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE it1.info = 'countries'
  AND mv25.info = 'rating'
  AND k.keyword IS NOT NULL
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mv25.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mv25.movie_id
  AND mi.movie_id = mv25.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id;
