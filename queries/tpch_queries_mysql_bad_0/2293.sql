SELECT REGION.R_COMMENT, NATION.N_COMMENT, SUM(NATION.N_REGIONKEY), MAX(NATION.N_REGIONKEY) FROM NATION, REGION GROUP BY REGION.R_COMMENT, NATION.N_COMMENT;
