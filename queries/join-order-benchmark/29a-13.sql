SELECT MIN(chn.name) AS voiced_char,
       MIN(n.name) AS voicing_actress,
       MIN(mv13.title) AS voiced_animation
FROM mv13 AS mv13,
    aka_name AS an,
     complete_cast AS cc,
     comp_cast_type AS cct1,
     comp_cast_type AS cct2,
     char_name AS chn,
     cast_info AS ci,
     info_type AS it,
     info_type AS it3,
     keyword AS k,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     person_info AS pi,
     role_type AS rt
WHERE cct1.kind ='cast'
  AND cct2.kind ='complete+verified'
  AND chn.name = 'Queen'
  AND ci.note IN ('(voice)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND it.info = 'release dates'
  AND it3.info = 'trivia'
  AND k.keyword = 'computer-animation'
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%200%'
       OR mi.info LIKE 'USA:%200%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND mv13.title = 'Shrek 2'
  AND mv13.production_year BETWEEN 2000 AND 2010
  AND mv13.id = mi.movie_id
  AND mv13.id = ci.movie_id
  AND mv13.id = mk.movie_id
  AND mv13.id = cc.movie_id
  AND mv13.movie_id = ci.movie_id
  AND mv13.movie_id = mi.movie_id
  AND mv13.movie_id = mk.movie_id
  AND mv13.movie_id = cc.movie_id
  AND mi.movie_id = ci.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi.movie_id = cc.movie_id
  AND ci.movie_id = mk.movie_id
  AND ci.movie_id = cc.movie_id
  AND mk.movie_id = cc.movie_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id
  AND n.id = pi.person_id
  AND ci.person_id = pi.person_id
  AND it3.id = pi.info_type_id
  AND k.id = mk.keyword_id
  AND cct1.id = cc.subject_id
  AND cct2.id = cc.status_id;

