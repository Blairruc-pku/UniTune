SELECT MIN(t.title) AS american_movie
FROM mv8 AS mv8,
    company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     title AS t
WHERE ct.kind = 'production companies'
  AND mc.note NOT LIKE '%(TV)%'
  AND mc.note LIKE '%(USA)%'
  AND mv8.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND t.production_year > 1990
  AND t.id = mv8.movie_id
  AND t.id = mc.movie_id
  AND mc.movie_id = mv8.movie_id
  AND ct.id = mc.company_type_id
  AND it.id = mv8.info_type_id;

