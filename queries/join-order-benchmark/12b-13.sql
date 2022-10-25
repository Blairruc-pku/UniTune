SELECT MIN(mi.info) AS budget,
       MIN(mv13.title) AS unsuccsessful_movie
FROM mv13 AS mv13,
    company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     movie_info AS mi,
     movie_info_idx AS mi_idx
WHERE ct.kind IS NOT NULL
  AND (ct.kind ='production companies'
       OR ct.kind = 'distributors')
  AND it1.info ='budget'
  AND it2.info ='bottom 10 rank'
  AND mv13.production_year >2000
  AND (mv13.title LIKE 'Birdemic%'
       OR mv13.title LIKE '%Movie%')
  AND mv13.id = mi.movie_id
  AND mv13.id = mi_idx.movie_id
  AND mi.info_type_id = it1.id
  AND mi_idx.info_type_id = it2.id
  AND ct.id = mv13.company_type_id
  AND mv13.movie_id = mi.movie_id
  AND mv13.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id;

