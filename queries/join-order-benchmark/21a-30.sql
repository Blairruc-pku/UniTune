SELECT MIN(cn.name) AS company_name,
       MIN(lt.link) AS link_type,
       MIN(mv30.title) AS western_follow_up
FROM mv30 AS mv30,
    company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     movie_link AS ml
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German')
  AND mv30.production_year BETWEEN 1950 AND 2000
  AND lt.id = ml.link_type_id
  AND ml.movie_id = mv30.id
  AND mv30.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mv30.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND mi.movie_id = mv30.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id
  AND ml.movie_id = mi.movie_id
  AND mk.movie_id = mi.movie_id
  AND mc.movie_id = mi.movie_id;
