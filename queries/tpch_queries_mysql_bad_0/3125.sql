SELECT PARTSUPP.PS_SUPPLYCOST, PART.P_COMMENT FROM PART, PARTSUPP WHERE PART.P_BRAND > 'BRAND#22  ' AND PART.P_BRAND < 'BRAND#31  ';