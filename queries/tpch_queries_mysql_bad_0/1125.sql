SELECT CUSTOMER.C_ACCTBAL, NATION.N_COMMENT, REGION.R_REGIONKEY FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY;
