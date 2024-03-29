SELECT MIN(mv1.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM mv1 as mv1,
     info_type AS it,
     movie_info_idx AS mi_idx,
     title AS t
WHERE it.info = 'bottom 10 rank'
  AND mv1.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND t.production_year >2000
  AND t.id = mv1.movie_id
  AND t.id = mi_idx.movie_id
  AND mv1.movie_id = mi_idx.movie_id
  AND it.id = mi_idx.info_type_id;