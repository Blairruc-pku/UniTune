SELECT REGION.R_NAME, NATION.N_COMMENT FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY WHERE NATION.N_REGIONKEY < 28461.92 AND REGION.R_COMMENT != '194.38';
