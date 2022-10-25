SELECT MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress_name,
       MIN(t.title) AS kung_fu_panda
FROM mv14 AS mv14,
    aka_name AS an,
     char_name AS chn,
     company_name AS cn,
     info_type AS it,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     role_type AS rt,
     title AS t
WHERE cn.country_code ='[us]'
  AND cn.name = 'DreamWorks Animation'
  AND it.info = 'release dates'
  AND k.keyword IN ('hero',
                    'martial-arts',
                    'hand-to-hand-combat',
                    'computer-animated-movie')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%201%'
       OR mi.info LIKE 'USA:%201%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.production_year > 2010
  AND t.title LIKE 'Kung Fu Panda%'
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = mv14.movie_id
  AND t.id = mk.movie_id
  AND mc.movie_id = mv14.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mi.movie_id = mv14.movie_id
  AND mi.movie_id = mk.movie_id
  AND mv14.movie_id = mk.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = mv14.person_id
  AND rt.id = mv14.role_id
  AND n.id = an.person_id
  AND mv14.person_id = an.person_id
  AND chn.id = mv14.person_role_id
  AND k.id = mk.keyword_id;

