SELECT NATION.N_NATIONKEY, SUPPLIER.S_NATIONKEY, MIN(SUPPLIER.S_COMMENT) FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY GROUP BY NATION.N_NATIONKEY, SUPPLIER.S_NATIONKEY;
