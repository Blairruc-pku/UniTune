SELECT NATION.N_COMMENT, SUM(NATION.N_NATIONKEY) FROM NATION GROUP BY NATION.N_COMMENT;
