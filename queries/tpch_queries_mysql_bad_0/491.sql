SELECT SUPPLIER.S_COMMENT, NATION.N_NATIONKEY FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY ORDER BY SUPPLIER.S_COMMENT DESC, NATION.N_NATIONKEY DESC;