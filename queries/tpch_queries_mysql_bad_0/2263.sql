SELECT REGION.R_COMMENT, NATION.N_COMMENT, COUNT(REGION.R_REGIONKEY) FROM NATION JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY GROUP BY REGION.R_COMMENT, NATION.N_COMMENT;