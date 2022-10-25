SELECT PART.P_CONTAINER, SUPPLIER.S_ACCTBAL, PARTSUPP.PS_AVAILQTY FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY WHERE PART.P_RETAILPRICE <= 1007.10 ORDER BY PARTSUPP.PS_AVAILQTY DESC, SUPPLIER.S_ACCTBAL ASC;
