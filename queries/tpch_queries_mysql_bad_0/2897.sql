SELECT CUSTOMER.C_ACCTBAL, NATION.N_COMMENT FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY ORDER BY NATION.N_COMMENT ASC;
