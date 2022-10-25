SELECT SUPPLIER.S_NAME, PART.P_PARTKEY, PARTSUPP.PS_PARTKEY FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_AVAILQTY <= 1226 AND PART.P_CONTAINER = 'SM BOX    ';
