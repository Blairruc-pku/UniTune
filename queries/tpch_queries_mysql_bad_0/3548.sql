SELECT PARTSUPP.PS_SUPPLYCOST, PART.P_CONTAINER, MIN(PART.P_NAME) FROM PART, PARTSUPP WHERE PARTSUPP.PS_AVAILQTY = 5299 AND PART.P_NAME >= 'CYAN ORCHID INDIAN CORNFLOWER SADDLE' GROUP BY PARTSUPP.PS_SUPPLYCOST, PART.P_CONTAINER ORDER BY MIN(PART.P_NAME) ASC;