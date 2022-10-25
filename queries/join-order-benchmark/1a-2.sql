SELECT MIN(mc.note) AS production_note,
       MIN(t.title) AS movie_title,
       MIN(t.production_year) AS movie_year
FROM mv2 as mv2,
     company_type AS ct,
     movie_companies AS mc,
     title AS t
WHERE ct.kind = 'production companies'
  AND mv2.info = 'top 250 rank'
  AND mc.note NOT LIKE '%(as Metro-Goldwyn-Mayer Pictures)%'
  AND (mc.note LIKE '%(co-production)%'
       OR mc.note LIKE '%(presents)%')
  AND ct.id = mc.company_type_id
  AND t.id = mc.movie_id
  AND t.id = mv2.movie_id
  AND mc.movie_id = mv2.movie_id;