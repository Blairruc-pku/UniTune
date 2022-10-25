SELECT mk.movie_id,
        k.keyword
FROM keyword AS k,
     movie_keyword AS mk
WHERE k.keyword ='character-name-in-title'
  AND mk.keyword_id = k.id;
