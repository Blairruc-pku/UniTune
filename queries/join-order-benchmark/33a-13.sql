SELECT MIN(mv13.name) AS first_company,
       MIN(cn2.name) AS second_company,
       MIN(mi_idx1.info) AS first_rating,
       MIN(mi_idx2.info) AS second_rating,
       MIN(mv13.title) AS first_movie,
       MIN(t2.title) AS second_movie
FROM mv13 AS mv13,
    company_name AS cn2,
     info_type AS it1,
     info_type AS it2,
     kind_type AS kt1,
     kind_type AS kt2,
     link_type AS lt,
     movie_companies AS mc2,
     movie_info_idx AS mi_idx1,
     movie_info_idx AS mi_idx2,
     movie_link AS ml,
     title AS t2
WHERE it1.info = 'rating'
  AND it2.info = 'rating'
  AND kt1.kind IN ('tv series')
  AND kt2.kind IN ('tv series')
  AND lt.link IN ('sequel',
                  'follows',
                  'followed by')
  AND mi_idx2.info < '3.0'
  AND t2.production_year BETWEEN 2005 AND 2008
  AND lt.id = ml.link_type_id
  AND mv13.id = ml.movie_id
  AND t2.id = ml.linked_movie_id
  AND it1.id = mi_idx1.info_type_id
  AND mv13.id = mi_idx1.movie_id
  AND kt1.id = mv13.kind_id
  AND ml.movie_id = mi_idx1.movie_id
  AND ml.movie_id = mv13.movie_id
  AND mi_idx1.movie_id = mv13.movie_id
  AND it2.id = mi_idx2.info_type_id
  AND t2.id = mi_idx2.movie_id
  AND kt2.id = t2.kind_id
  AND cn2.id = mc2.company_id
  AND t2.id = mc2.movie_id
  AND ml.linked_movie_id = mi_idx2.movie_id
  AND ml.linked_movie_id = mc2.movie_id
  AND mi_idx2.movie_id = mc2.movie_id;

