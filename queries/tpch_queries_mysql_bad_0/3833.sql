SELECT PART.P_RETAILPRICE, PARTSUPP.PS_AVAILQTY FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY WHERE PARTSUPP.PS_SUPPLYCOST > 566.34;
