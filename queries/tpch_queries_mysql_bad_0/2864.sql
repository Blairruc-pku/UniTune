SELECT CUSTOMER.C_COMMENT, NATION.N_NAME, REGION.R_REGIONKEY FROM REGION, NATION, CUSTOMER WHERE REGION.R_COMMENT = '6214.56' ORDER BY REGION.R_REGIONKEY DESC, CUSTOMER.C_COMMENT ASC;
