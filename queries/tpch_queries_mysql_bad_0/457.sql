SELECT NATION.N_NATIONKEY, PARTSUPP.PS_COMMENT, SUPPLIER.S_PHONE FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY ORDER BY SUPPLIER.S_PHONE ASC, NATION.N_NATIONKEY ASC;