SELECT CUSTOMER.C_ACCTBAL, NATION.N_NAME FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY ORDER BY NATION.N_NAME DESC;
