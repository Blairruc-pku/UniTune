SELECT it.info,
        mi_idx.info AS minfo,
        mi_idx.movie_id
FROM info_type AS it,
     movie_info_idx AS mi_idx
WHERE it.info = 'rating'
  AND mi_idx.info < '8.5'
  AND mi_idx.info_type_id = it.id;