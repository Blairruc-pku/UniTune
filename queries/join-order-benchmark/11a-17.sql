SELECT MIN(cn.name) AS from_company,
       MIN(lt.link) AS movie_link_type,
       MIN(mv17.title) AS non_polish_sequel_movie
FROM mv17 AS mv17,
    company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_keyword AS mk,
     movie_link AS ml
WHERE cn.country_code !='[pl]'
  AND (cn.name LIKE '%Film%'
       OR cn.name LIKE '%Warner%')
  AND ct.kind ='production companies'
  AND k.keyword ='sequel'
  AND lt.link LIKE '%follow%'
  AND mc.note IS NULL
  AND mv17.production_year BETWEEN 1950 AND 2000
  AND lt.id = ml.link_type_id
  AND ml.movie_id = mv17.id
  AND mv17.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mv17.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id;

