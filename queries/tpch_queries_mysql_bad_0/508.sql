SELECT NATION.N_REGIONKEY, REGION.R_COMMENT, MAX(REGION.R_COMMENT) FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY GROUP BY NATION.N_REGIONKEY, REGION.R_COMMENT;