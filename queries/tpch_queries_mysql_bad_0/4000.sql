SELECT CUSTOMER.C_NATIONKEY, NATION.N_NATIONKEY, REGION.R_COMMENT FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY ORDER BY REGION.R_COMMENT DESC;
