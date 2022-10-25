SELECT mc.company_id,
        mc.company_type_id,
        mc.movie_id,
        mi.info_type_id,
        mi.note,
        mi.info
FROM movie_companies AS mc,
     movie_info AS mi
WHERE mc.note LIKE '%(200%)%'
  AND mc.note LIKE '%(worldwide)%'
  AND mi.note LIKE '%internet%'
  AND mi.info LIKE 'USA:% 200%';