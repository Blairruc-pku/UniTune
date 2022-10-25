SELECT cn.country_code,
        cn.name,
        mc.company_id,
        mc.company_type_id,
        mc.note,
        mc.movie_id,
        ct.kind
FROM company_name AS cn,
     movie_companies AS mc,
     company_type AS ct
WHERE cn.id = mc.company_id
  AND ct.id = mc.company_type_id;