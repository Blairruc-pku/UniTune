SELECT NATION.N_COMMENT, SUPPLIER.S_NAME FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_ADDRESS >= 'S,4TICNGB4UO6PASQNBUQ' AND SUPPLIER.S_NATIONKEY != 17 ORDER BY NATION.N_COMMENT DESC;
