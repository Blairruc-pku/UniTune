SELECT PARTSUPP.PS_PARTKEY, PART.P_RETAILPRICE FROM PART, PARTSUPP ORDER BY PART.P_RETAILPRICE ASC, PARTSUPP.PS_PARTKEY ASC;