SELECT REGION.R_NAME, NATION.N_REGIONKEY, MAX(NATION.N_REGIONKEY) FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY GROUP BY REGION.R_NAME, NATION.N_REGIONKEY;
