SELECT NATION.N_COMMENT, SUPPLIER.S_NATIONKEY FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY ORDER BY NATION.N_COMMENT ASC;
