SELECT REGION.R_NAME, NATION.N_NATIONKEY FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY ORDER BY REGION.R_NAME DESC, NATION.N_NATIONKEY ASC;
