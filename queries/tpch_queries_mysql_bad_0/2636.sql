SELECT PARTSUPP.PS_COMMENT, SUPPLIER.S_PHONE, NATION.N_COMMENT FROM PARTSUPP JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY ORDER BY NATION.N_COMMENT ASC, SUPPLIER.S_PHONE ASC;
