SELECT NATION.N_NAME, REGION.R_REGIONKEY, COUNT(NATION.N_NAME) FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY GROUP BY NATION.N_NAME, REGION.R_REGIONKEY;
