SELECT PARTSUPP.PS_SUPPLYCOST, PART.P_TYPE, MAX(PART.P_RETAILPRICE) FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY GROUP BY PARTSUPP.PS_SUPPLYCOST, PART.P_TYPE;
