SELECT MIN(t.title) AS movie_title
FROM mv8 AS mv8,
    keyword AS k,
     movie_keyword AS mk,
     title AS t
WHERE k.keyword LIKE '%sequel%'
  AND mv8.info IN ('Sweden',
                  'Norway',
                  'Germany',
                  'Denmark',
                  'Swedish',
                  'Denish',
                  'Norwegian',
                  'German',
                  'USA',
                  'American')
  AND t.production_year > 1990
  AND t.id = mv8.movie_id
  AND t.id = mk.movie_id
  AND mk.movie_id = mv8.movie_id
  AND k.id = mk.keyword_id;

