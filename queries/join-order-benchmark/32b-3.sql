SELECT MIN(lt.link) AS link_type,
       MIN(t1.title) AS first_movie,
       MIN(t2.title) AS second_movie
FROM mv3 AS mv3,
     link_type AS lt,
     movie_link AS ml,
     title AS t1,
     title AS t2
WHERE t1.id = mv3.movie_id
  AND ml.movie_id = t1.id
  AND ml.linked_movie_id = t2.id
  AND lt.id = ml.link_type_id
  AND mv3.movie_id = t1.id;
