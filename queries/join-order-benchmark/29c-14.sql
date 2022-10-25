SELECT MIN(chn.name) AS voiced_char,
       MIN(n.name) AS voicing_actress,
       MIN(t.title) AS voiced_animation
FROM mv14 AS mv14,
    aka_name AS an,
     complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     company_name AS cn,
     info_type AS it,
     info_type AS it3,
     keyword AS k,
     movie_companies AS mc,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     person_info AS pi,
     role_type AS rt,
     title AS t
WHERE cct1.kind ='cast'
  AND cct2.kind ='complete+verified'
  AND cn.country_code ='[us]'
  AND it.info = 'release dates'
  AND it3.info = 'trivia'
  AND k.keyword = 'computer-animation'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND t.production_year BETWEEN 2000 AND 2010
  AND t.id = mi.movie_id
  AND t.id = mc.movie_id
  AND t.id = mv14.movie_id
  AND t.id = mk.movie_id
  AND t.id = cc.movie_id
  AND mc.movie_id = mv14.movie_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mk.movie_id
  AND mc.movie_id = cc.movie_id
  AND mi.movie_id = mv14.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND mv14.movie_id = mk.movie_id
  AND mv14.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND cn.id = mc.company_id
  AND it.id = mi.info_type_id
  AND n.id = mv14.person_id
  AND rt.id = mv14.role_id
  AND n.id = an.person_id
  AND mv14.person_id = an.person_id
  AND chn.id = mv14.person_role_id
  AND n.id = pi.person_id
  AND mv14.person_id = pi.person_id
  AND it3.id = pi.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;

