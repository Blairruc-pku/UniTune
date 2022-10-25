SELECT MIN(mv13.name) AS movie_company,
       MIN(mi_idx.info) AS rating,
       MIN(mv13.title) AS mainstream_movie
FROM mv13 AS mv13,
     company_type AS ct,
     info_type AS it1,
     info_type AS it2,
     movie_info AS mi,
     movie_info_idx AS mi_idx
WHERE ct.kind = 'production companies'
  AND it1.info = 'genres'
  AND it2.info = 'rating'
  AND mi.info IN ('Drama',
                  'Horror',
                  'Western',
                  'Family')
  AND mi_idx.info > '7.0'
  AND mv13.production_year BETWEEN 2000 AND 2010
  AND mv13.id = mi.movie_id
  AND mv13.id = mi_idx.movie_id
  AND mi.info_type_id = it1.id
  AND mi_idx.info_type_id = it2.id
  AND ct.id = mv13.company_type_id
  AND mv13.movie_id = mi.movie_id
  AND mv13.movie_id = mi_idx.movie_id
  AND mi.movie_id = mi_idx.movie_id;

