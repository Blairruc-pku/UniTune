SELECT mc.movie_id,
       mc.note,
       mc.company_id
FROM company_type AS ct,
     movie_companies AS mc
WHERE ct.kind = 'production companies'
  AND ct.id = mc.company_type_id;