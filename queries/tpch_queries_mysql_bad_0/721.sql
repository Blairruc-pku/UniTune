SELECT PART.P_BRAND, PARTSUPP.PS_SUPPLYCOST, MIN(PARTSUPP.PS_PARTKEY) FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY GROUP BY PART.P_BRAND, PARTSUPP.PS_SUPPLYCOST;
