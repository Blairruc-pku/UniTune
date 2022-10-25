SELECT mi.info_type_id,
        mi.note,
        mi.movie_id,
        mi.info
FROM movie_info AS mi
WHERE mi.info IN ('Drama',
                  'Horror',
                  'Western',
                  'Family');