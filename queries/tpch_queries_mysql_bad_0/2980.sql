SELECT SUPPLIER.S_PHONE, NATION.N_NATIONKEY FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY ORDER BY SUPPLIER.S_PHONE ASC;
