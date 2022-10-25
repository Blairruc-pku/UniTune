SELECT ci.role_id,
        ci.person_role_id,
        ci.person_id,
        ci.note,
        ci.movie_id,
        n.gender,
        n.name,
        n.id,
        n.name_pcode_cf
FROM cast_info AS ci,
     name AS n
WHERE n.name_pcode_cf LIKE 'D%'
  AND ci.person_id = n.id;