SELECT MIN(t.title) AS movie_title
FROM mv6 AS mv6,
     keyword AS k,
     movie_keyword AS mk,
     title AS t
WHERE mv6.country_code ='[sm]'
  AND k.keyword ='character-name-in-title'
  AND mv6.movie_id = t.id
  AND t.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mv6.movie_id = mk.movie_id;