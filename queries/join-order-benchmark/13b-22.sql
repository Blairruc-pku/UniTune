SELECT MIN(cn.name) AS producing_company,
       MIN(miidx.info) AS rating,
       MIN(mv22.title) AS movie_about_winning
FROM mv22 AS mv22,
    company_name AS cn,
     company_type AS ct,
     info_type AS it,
     info_type AS it2,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS miidx
WHERE cn.country_code ='[us]'
  AND ct.kind ='production companies'
  AND it.info ='rating'
  AND it2.info ='release dates'
  AND mv22.title != ''
  AND (mv22.title LIKE '%Champion%'
       OR mv22.title LIKE '%Loser%')
  AND mi.movie_id = mv22.id
  AND it2.id = mi.info_type_id
  AND mc.movie_id = mv22.id
  AND cn.id = mc.company_id
  AND ct.id = mc.company_type_id
  AND miidx.movie_id = mv22.id
  AND it.id = miidx.info_type_id
  AND mi.movie_id = miidx.movie_id
  AND mi.movie_id = mc.movie_id
  AND miidx.movie_id = mc.movie_id;
