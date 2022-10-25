SELECT t.production_year,
        t.episode_nr,
        t.title,
        t.id,
        t.kind_id
FROM title AS t
WHERE t.title != ''
  AND (t.title LIKE '%Champion%'
       OR t.title LIKE '%Loser%');