SELECT NATION.N_COMMENT, REGION.R_COMMENT FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY ORDER BY REGION.R_COMMENT DESC, NATION.N_COMMENT ASC;