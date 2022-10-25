SELECT PARTSUPP.PS_COMMENT, PART.P_COMMENT, REGION.R_NAME, SUPPLIER.S_PHONE, NATION.N_COMMENT, MIN(PART.P_NAME) FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY GROUP BY PARTSUPP.PS_COMMENT, PART.P_COMMENT, REGION.R_NAME, SUPPLIER.S_PHONE, NATION.N_COMMENT ORDER BY MIN(PART.P_NAME) ASC;