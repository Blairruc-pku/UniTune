SELECT kt.kind,
        t.production_year,
        t.episode_nr,
        t.title,
        t.id,
        t.kind_id
FROM kind_type AS kt,
     title AS t
WHERE kt.kind ='movie'
  AND kt.id = t.kind_id;