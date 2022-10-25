SELECT MIN(mi.info) AS budget,
       MIN(mv18.title) AS unsuccsessful_movie
FROM mv18 AS mv18,
    company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     movie_companies AS mc,
     movie_info AS mi,
     movie_info_idx AS mi_idx
WHERE cn.country_code ='[us]'
  AND ct.kind IS NOT NULL
  AND (ct.kind ='production companies'
       OR ct.kind = 'distributors')
  AND it1.info ='budget'
  AND it2.info ='bottom 10 rank'
  AND (mv18.title LIKE 'Birdemic%'
       OR mv18.title LIKE '%Movie%')
  AND mv18.id = mi.movie_id
  AND mv18.id = mi_idx.movie_id
  AND mi.info_type_id = it1.id
  AND mi_idx.info_type_id = it2.id
  AND mv18.id = mc.movie_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id;
