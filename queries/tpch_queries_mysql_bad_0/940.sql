SELECT NATION.N_NAME, SUPPLIER.S_NATIONKEY FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY ORDER BY SUPPLIER.S_NATIONKEY ASC, NATION.N_NAME DESC;
