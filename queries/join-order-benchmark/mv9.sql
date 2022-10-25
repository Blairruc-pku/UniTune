SELECT t.id,
        t.title,
        t.kind_id,
        t.production_year,
        t.episode_of_id,
        t.season_nr,
        t.episode_nr,
        k.keyword
FROM keyword AS k,
     movie_keyword AS mk,
     title AS t
WHERE mk.keyword_id = k.id
  AND t.id = mk.movie_id
  AND k.keyword = 'marvel-cinematic-universe';