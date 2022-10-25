SELECT MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_movie
FROM mv14 AS mv14,
    aka_name AS an,
     char_name AS chn,
     company_name AS cn,
     info_type AS it,
     movie_companies AS mc,
     movie_info AS mi,
     name AS n,
     role_type AS rt,
     title AS t
WHERE cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND mc.note IS NOT NULL
  AND (mc.note LIKE '%(USA)%'
       OR mc.note LIKE '%(worldwide)%')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender ='f'
  AND n.name LIKE '%Ang%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2005 AND 2009
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = mv14.movie_id
  AND mc.movie_id = mv14.movie_id
  AND mc.movie_id = mi.movie_id
  AND mi.movie_id = mv14.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = mv14.person_id
  AND rt.id = mv14.role_id
  AND n.id = an.person_id
  AND mv14.person_id = an.person_id
  AND chn.id = mv14.person_role_id;
