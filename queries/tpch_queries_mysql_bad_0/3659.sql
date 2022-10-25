SELECT REGION.R_COMMENT, CUSTOMER.C_NAME, NATION.N_NAME, COUNT(CUSTOMER.C_COMMENT) FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY GROUP BY REGION.R_COMMENT, CUSTOMER.C_NAME, NATION.N_NAME;
