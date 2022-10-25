SELECT MIN(cn.name) AS movie_company,
       MIN(mv25.minfo) AS rating,
       MIN(t.title) AS western_violent_movie
FROM mv25 AS mv25,
    company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND mv25.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Germany',
                  'German',
                  'USA',
                  'American')
  AND mv25.minfo < '7.0'
  AND t.production_year > 2008
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mv25.movie_id
  AND t.id = mc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mv25.movie_id
  AND mk.movie_id = mc.movie_id
  AND mi.movie_id = mv25.movie_id
  AND mi.movie_id = mc.movie_id
  AND mc.movie_id = mv25.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id;

