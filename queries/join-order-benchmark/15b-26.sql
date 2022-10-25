SELECT MIN(mv26.info) AS release_date,
       MIN(t.title) AS youtube_movie
FROM mv26 AS mv26,
    aka_title AS at,
     company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     keyword AS k,
     movie_keyword AS mk,
     title AS t
WHERE cn.country_code = '[us]'
  AND cn.name = 'YouTube'
  AND it1.info = 'release dates'
  AND t.production_year BETWEEN 2005 AND 2010
  AND t.id = at.movie_id
  AND t.id = mv26.movie_id
  AND t.id = mk.movie_id
  AND t.id = mv26.movie_id
  AND mk.movie_id = mv26.movie_id
  AND mk.movie_id = mv26.movie_id
  AND mk.movie_id = at.movie_id
  AND mv26.movie_id = at.movie_id
  AND mv26.movie_id = at.movie_id
  AND k.id = mk.keyword_id
  AND it1.id = mv26.info_type_id
  AND cn.id = mv26.company_id
  AND ct.id = mv26.company_type_id;
