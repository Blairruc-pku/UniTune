SELECT PART.P_RETAILPRICE, PARTSUPP.PS_SUPPLYCOST FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY ORDER BY PARTSUPP.PS_SUPPLYCOST ASC;
