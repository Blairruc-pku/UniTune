SELECT ci.role_id,
        ci.person_role_id,
        ci.person_id,
        ci.movie_id,
        cn.country_code,
        cn.name,
        mc.company_id,
        mc.company_type_id,
        mc.note,
        rt.role,
        t.production_year,
        t.episode_nr,
        t.title,
        t.id,
        t.kind_id
FROM cast_info AS ci,
     company_name AS cn,
     movie_companies AS mc,
     role_type AS rt,
     title AS t
WHERE ci.note LIKE '%(producer)%'
  AND cn.country_code = '[ru]'
  AND rt.role = 'actor'
  AND t.id = mc.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mc.movie_id
  AND rt.id = ci.role_id
  AND cn.id = mc.company_id;