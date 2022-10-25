SELECT MIN(cn.name) AS from_company,
       MIN(mc.note) AS production_note,
       MIN(mv17.title) AS movie_based_on_book
FROM mv17 AS mv17,
    company_name AS cn,
     company_type AS ct,
     keyword AS k,
     link_type AS lt,
     movie_companies AS mc,
     movie_keyword AS mk,
     movie_link AS ml
WHERE cn.country_code !='[pl]'
  AND ct.kind != 'production companies'
  AND ct.kind IS NOT NULL
  AND k.keyword IN ('sequel',
                    'revenge',
                    'based-on-novel')
  AND mc.note IS NOT NULL
  AND mv17.production_year > 1950
  AND lt.id = ml.link_type_id
  AND ml.movie_id = mv17.id
  AND mv17.id = mk.movie_id
  AND mk.keyword_id = k.id
  AND mv17.id = mc.movie_id
  AND mc.company_type_id = ct.id
  AND mc.company_id = cn.id
  AND ml.movie_id = mk.movie_id
  AND ml.movie_id = mc.movie_id
  AND mk.movie_id = mc.movie_id;

