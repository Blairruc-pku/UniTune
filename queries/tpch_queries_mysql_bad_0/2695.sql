SELECT SUPPLIER.S_NAME, NATION.N_REGIONKEY FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_NAME = 'SUPPLIER#000000006       ' ORDER BY NATION.N_REGIONKEY ASC;
