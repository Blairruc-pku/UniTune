SELECT MIN(mv2.minfo) AS rating,
       MIN(t.title) AS movie_title
FROM mv2 AS mv2,
     keyword AS k,
     movie_keyword AS mk,
     title AS t
WHERE mv2.info ='rating'
  AND k.keyword LIKE '%sequel%'
  AND mv2.minfo > '2.0'
  AND t.production_year > 1990
  AND t.id = mv2.movie_id
  AND t.id = mk.movie_id
  AND mk.movie_id = mv2.movie_id
  AND k.id = mk.keyword_id;