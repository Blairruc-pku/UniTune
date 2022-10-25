SELECT mk.movie_id,
        k.keyword
FROM keyword AS k,
     movie_keyword AS mk
WHERE mk.keyword_id = k.id;
