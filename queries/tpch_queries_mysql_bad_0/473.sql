SELECT CUSTOMER.C_COMMENT, NATION.N_REGIONKEY FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY ORDER BY CUSTOMER.C_COMMENT DESC, NATION.N_REGIONKEY ASC;