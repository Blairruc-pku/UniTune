SELECT MIN(t.title) AS american_vhs_movie
FROM mv8 AS mv8,
    company_type AS ct,
     info_type AS it,
     movie_companies AS mc,
     title AS t
WHERE ct.kind = 'production companies'
  AND mc.note LIKE '%(VHS)%'
  AND mc.note LIKE '%(USA)%'
  AND mc.note LIKE '%(1994)%'
  AND mv8.info IN ('USA',
                  'America')
  AND t.production_year > 2010
  AND t.id = mv8.movie_id
  AND t.id = mc.movie_id
  AND mc.movie_id = mv8.movie_id
  AND ct.id = mc.company_type_id
  AND it.id = mv8.info_type_id;

