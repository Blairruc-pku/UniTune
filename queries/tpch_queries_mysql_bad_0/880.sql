SELECT REGION.R_REGIONKEY, NATION.N_REGIONKEY FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY WHERE NATION.N_NAME > 'CLERK#000000998';
