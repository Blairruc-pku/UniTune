SELECT it.info,
        mi_idx.movie_id,
        mi_idx.info AS minfo
FROM info_type AS it,
     movie_info_idx AS mi_idx
WHERE it.id = mi_idx.info_type_id;