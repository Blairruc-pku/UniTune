SELECT NATION.N_COMMENT, REGION.R_COMMENT, MAX(REGION.R_REGIONKEY) FROM NATION, REGION GROUP BY NATION.N_COMMENT, REGION.R_COMMENT;