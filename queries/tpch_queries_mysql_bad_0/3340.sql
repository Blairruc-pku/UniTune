SELECT NATION.N_COMMENT, CUSTOMER.C_ACCTBAL, REGION.R_COMMENT, COUNT(CUSTOMER.C_NAME) FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY GROUP BY NATION.N_COMMENT, CUSTOMER.C_ACCTBAL, REGION.R_COMMENT;
