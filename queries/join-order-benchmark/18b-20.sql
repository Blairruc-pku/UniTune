SELECT MIN(mi.info) AS movie_budget,
       MIN(mv20.minfo) AS movie_votes,
       MIN(t.title) AS movie_title
FROM mv20 AS mv20,
    cast_info AS ci,
     info_type AS it1,
     movie_info AS mi,
     name AS n,
     title AS t
WHERE ci.note IN ('(writer)',
                  '(head writer)',
                  '(written by)',
                  '(story)',
                  '(story editor)')
  AND it1.info = 'genres'
  AND mv20.info = 'rating'
  AND mi.info IN ('Horror',
                  'Thriller')
  AND mi.note IS NULL
  AND mv20.minfo > '8.0'
  AND n.gender IS NOT NULL
  AND n.gender = 'f'
  AND t.production_year BETWEEN 2008 AND 2014
  AND t.id = mi.movie_id
  AND t.id = mv20.movie_id
  AND t.id = ci.movie_id
  AND ci.movie_id = mi.movie_id
  AND ci.movie_id = mv20.movie_id
  AND mi.movie_id = mv20.movie_id
  AND n.id = ci.person_id
  AND it1.id = mi.info_type_id;

