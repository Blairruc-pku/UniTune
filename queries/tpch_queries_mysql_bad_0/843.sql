SELECT NATION.N_NAME, REGION.R_NAME FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY ORDER BY REGION.R_NAME ASC, NATION.N_NAME DESC;
