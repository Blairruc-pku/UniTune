SELECT NATION.N_NAME, SUPPLIER.S_NAME, REGION.R_REGIONKEY FROM SUPPLIER, NATION, REGION ORDER BY REGION.R_REGIONKEY DESC, NATION.N_NAME ASC;
