SELECT PARTSUPP.PS_PARTKEY, PART.P_RETAILPRICE FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY;