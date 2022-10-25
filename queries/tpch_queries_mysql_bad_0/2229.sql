SELECT SUPPLIER.S_ACCTBAL, NATION.N_NAME, COUNT(NATION.N_COMMENT), MAX(NATION.N_NAME) FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY GROUP BY SUPPLIER.S_ACCTBAL, NATION.N_NAME ORDER BY NATION.N_NAME DESC;
