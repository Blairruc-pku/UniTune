SELECT NATION.N_NATIONKEY, REGION.R_REGIONKEY FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY WHERE NATION.N_NAME > '7292';
