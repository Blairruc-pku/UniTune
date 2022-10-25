SELECT MIN(t.title) AS typical_european_movie
FROM mv8 AS mv8,
    company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     title AS t
WHERE ct.kind = 'production companies'
  AND mc.note LIKE '%(theatrical)%'
  AND mc.note LIKE '%(France)%'
  AND mv8.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German')
  AND t.production_year > 2005
  AND t.id = mv8.movie_id
  AND t.id = mc.movie_id
  AND mc.movie_id = mv8.movie_id
  AND ct.id = mc.company_type_id
  AND it.id = mv8.info_type_id;
