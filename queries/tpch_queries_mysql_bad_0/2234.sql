SELECT CUSTOMER.C_COMMENT, NATION.N_COMMENT, MIN(NATION.N_NATIONKEY) FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY GROUP BY CUSTOMER.C_COMMENT, NATION.N_COMMENT;
