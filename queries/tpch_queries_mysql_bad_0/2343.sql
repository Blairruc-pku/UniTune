SELECT NATION.N_NAME, CUSTOMER.C_COMMENT, COUNT(CUSTOMER.C_COMMENT) FROM NATION, CUSTOMER GROUP BY NATION.N_NAME, CUSTOMER.C_COMMENT;