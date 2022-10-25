SELECT PART.P_TYPE, SUPPLIER.S_SUPPKEY, PARTSUPP.PS_COMMENT FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_PARTKEY >= 113 AND PART.P_SIZE >= 39 ORDER BY SUPPLIER.S_SUPPKEY ASC, PART.P_TYPE DESC, PARTSUPP.PS_COMMENT DESC;
