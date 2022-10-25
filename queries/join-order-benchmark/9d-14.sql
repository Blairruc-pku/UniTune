SELECT MIN(an.name) AS alternative_name,
       MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS american_movie
FROM mv14 AS mv14,
    aka_name AS an,
     char_name AS chn,
     company_name AS cn,
     movie_companies AS mc,
     name AS n,
     role_type AS rt,
     title AS t
WHERE cn.country_code ='[us]'
  AND n.gender ='f'
  AND rt.role ='actress'
  AND mv14.movie_id = t.id
  AND t.id = mc.movie_id
  AND mv14.movie_id = mc.movie_id
  AND mc.company_id = cn.id
  AND mv14.role_id = rt.id
  AND n.id = mv14.person_id
  AND chn.id = mv14.person_role_id
  AND an.person_id = n.id
  AND an.person_id = mv14.person_id;