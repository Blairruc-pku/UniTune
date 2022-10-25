SELECT MIN(kt.kind) AS movie_kind,
       MIN(mv13.title) AS complete_nerdy_internet_movie
FROM mv13 AS mv13,
    complete_cast AS cc,
     comp_cast_type AS cct1,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     kind_type AS kt,
     movie_info AS mi,
     movie_keyword AS mk
WHERE cct1.kind = 'complete+verified'
  AND it1.info = 'release dates'
  AND k.keyword IN ('nerd',
                    'loner',
                    'alienation',
                    'dignity')
  AND kt.kind IN ('movie')
  AND mi.note LIKE '%internet%'
  AND mi.info LIKE 'USA:% 200%'
  AND mv13.production_year > 2000
  AND kt.id = mv13.kind_id
  AND mv13.id = mi.movie_id
  AND mv13.id = mk.movie_id
  AND mv13.id = cc.movie_id
  AND mk.movie_id = mi.movie_id
  AND mk.movie_id = mv13.movie_id
  AND mk.movie_id = cc.movie_id
  AND mi.movie_id = mv13.movie_id
  AND mi.movie_id = cc.movie_id
  AND mv13.movie_id = cc.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mi.info_type_id
  AND cct1.id = cc.status_id;

