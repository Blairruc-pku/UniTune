SELECT NATION.N_COMMENT, REGION.R_COMMENT, MIN(NATION.N_NATIONKEY) FROM NATION, REGION GROUP BY NATION.N_COMMENT, REGION.R_COMMENT HAVING MIN(NATION.N_NATIONKEY) = PART ORDER BY REGION.R_COMMENT ASC;
