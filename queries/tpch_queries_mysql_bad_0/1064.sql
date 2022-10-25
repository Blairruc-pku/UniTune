SELECT PARTSUPP.PS_COMMENT, NATION.N_NAME, PART.P_MFGR, SUPPLIER.S_NAME FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY ORDER BY SUPPLIER.S_NAME DESC, NATION.N_NAME ASC, PARTSUPP.PS_COMMENT ASC;