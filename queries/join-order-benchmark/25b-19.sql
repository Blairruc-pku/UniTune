SELECT MIN(mi.info) AS movie_budget,
       MIN(mi_idx.info) AS movie_votes,
       MIN(n.name) AS male_writer,
       MIN(mv19.title) AS violent_movie_title
FROM mv19 AS mv19,
    cast_info AS ci,
     info_type AS it1,
     info_type AS it2,
     keyword AS k,
     movie_info AS mi,
     movie_info_idx AS mi_idx,
     movie_keyword AS mk,
     name AS n
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND it2.info = 'votes'
  AND k.keyword IN ('murder',
                    'blood',
                    'gore',
                    'death',
                    'female-nudity')
  AND mi.info = 'Horror'
  AND n.gender = 'm'
  AND mv19.title LIKE 'Vampire%'
  AND mv19.id = mi.movie_id
  AND mv19.id = mi_idx.movie_id
  AND mv19.id = ci.movie_id
  AND mv19.id = mk.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mi_idx.movie_id
  AND ci.movie_id = mk.movie_id
  AND mi.movie_id = mi_idx.movie_id
  AND mi.movie_id = mk.movie_id
  AND mi_idx.movie_id = mk.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id
  AND it2.id = mi_idx.info_type_id
  AND k.id = mk.keyword_id;

