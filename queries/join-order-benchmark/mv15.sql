SELECT cn.country_code,
        cn.name,
        mc.company_id,
        mc.company_type_id,
        mc.note,
        mc.movie_id,
        t.production_year,
        t.episode_nr,
        t.title,
        t.id,
        t.kind_id
FROM company_name AS cn,
     movie_companies AS mc,
     title AS t
WHERE cn.country_code ='[ru]'
  AND t.id = mc.movie_id
  AND mc.company_id = cn.id;