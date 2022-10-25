SELECT MIN(cn.name) AS movie_company,
       MIN(mv20.minfo) AS rating,
       MIN(t.title) AS mainstream_movie
FROM mv20 AS mv20,
    company_name AS cn,
     company_type AS ct,
     info_type AS it1,
     movie_companies AS mc,
     movie_info AS mi,
     title AS t
WHERE cn.country_code = '[us]'
  AND ct.kind = 'production companies'
  AND it1.info = 'genres'
  AND mv20.info = 'rating'
  AND mi.info IN ('Drama',
                  'Horror',
                  'Western',
                  'Family')
  AND t.production_year BETWEEN 2000 AND 2010
  AND t.id = mi.movie_id
  AND t.id = mv20.movie_id
  AND mi.info_type_id = it1.id
  AND t.id = mc.movie_id
  AND ct.id = mc.company_type_id
  AND cn.id = mc.company_id
  AND mc.movie_id = mi.movie_id
  AND mc.movie_id = mv20.movie_id
  AND mi.movie_id = mv20.movie_id;
  