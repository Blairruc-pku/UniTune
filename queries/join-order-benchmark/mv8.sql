SELECT mi.info_type_id,
        mi.note,
        mi.movie_id,
        mi.info
FROM movie_info AS mi
WHERE mi.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'Bulgaria',
                  'USA',
                  'American');