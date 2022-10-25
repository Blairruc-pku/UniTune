SELECT MIN(cn.name) AS movie_company,
       MIN(mv24.minfo) AS rating,
       MIN(t.title) AS complete_euro_dark_movie
FROM mv24 AS mv24,
    complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     title AS t
WHERE cct1.kind = 'crew'
  AND cct2.kind != 'complete+verified'
  AND cn.country_code != '[us]'
  AND it1.info = 'countries'
  AND mv24.info = 'rating'
  AND k.keyword IN ('murder',
                    'murder-in-title',
                    'blood',
                    'violence')
  AND kt.kind IN ('movie',
                  'episode')
  AND mc.note NOT LIKE '%(USA)%'
  AND mc.note LIKE '%(200%)%'
  AND mi.info IN ('Sweden',
                  'Germany',
                  'Swedish',
                  'German')
  AND mv24.minfo > '6.5'
  AND t.production_year > 2005
  AND kt.id = t.kind_id
  AND t.id = mi.movie_id
  AND t.id = mk.movie_id
  AND t.id = mv24.movie_id
  AND t.id = mc.movie_id
  AND t.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mv24.movie_id
  AND mk.movie_id = mc.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mv24.movie_id
  AND mi.movie_id = mc.movie_id
  AND mi.movie_id = cc.movie_id
  AND mc.movie_id = mv24.movie_id
  AND mc.movie_id = cc.movie_id
  AND mv24.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;

