SELECT PART.P_PARTKEY, PARTSUPP.PS_AVAILQTY FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY ORDER BY PART.P_PARTKEY ASC, PARTSUPP.PS_AVAILQTY DESC;
