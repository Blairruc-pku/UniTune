SELECT MIN(chn.name) AS voiced_char_name,
       MIN(n.name) AS voicing_actress_name,
       MIN(mv13.title) AS voiced_action_movie_jap_eng
FROM mv13 AS mv13,
    aka_name AS an,
     char_name AS chn,
     cast_info AS ci,
     info_type AS it,
     keyword AS k,
     movie_info AS mi,
     movie_keyword AS mk,
     name AS n,
     role_type AS rt
WHERE ci.note IN ('(voice)',
                  '(voice: Japanese version)',
                  '(voice) (uncredited)',
                  '(voice: English version)')
  AND it.info = 'release dates'
  AND k.keyword IN ('hero',
                    'martial-arts',
                    'hand-to-hand-combat')
  AND mi.info IS NOT NULL
  AND (mi.info LIKE 'Japan:%201%'
       OR mi.info LIKE 'USA:%201%')
  AND n.gender ='f'
  AND n.name LIKE '%An%'
  AND rt.role ='actress'
  AND mv13.production_year > 2010
  AND mv13.id = mi.movie_id
  AND mv13.id = ci.movie_id
  AND mv13.id = mk.movie_id
  AND mv13.movie_id = ci.movie_id
  AND mv13.movie_id = mi.movie_id
  AND mv13.movie_id = mk.movie_id
  AND mi.movie_id = ci.movie_id
  AND mi.movie_id = mk.movie_id
  AND ci.movie_id = mk.movie_id
  AND it.id = mi.info_type_id
  AND n.id = ci.person_id
  AND rt.id = ci.role_id
  AND n.id = an.person_id
  AND ci.person_id = an.person_id
  AND chn.id = ci.person_role_id
  AND k.id = mk.keyword_id;

