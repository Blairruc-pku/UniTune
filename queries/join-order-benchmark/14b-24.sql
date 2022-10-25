SELECT MIN(mv24.minfo) AS rating,
       MIN(t.title) AS western_dark_production
FROM mv24 AS mv24,
    info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE it1.info = 'countries'
  AND mv24.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title')
  AND kt.kind = 'movie'
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
  AND t.production_year > 2010
  AND (t.title LIKE '%murder%'
       OR t.title LIKE '%Murder%'
       OR t.title LIKE '%Mord%')
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mv24.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mv24.movie_id
  AND mi.movie_id = mv24.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id;

