SELECT NATION.N_NATIONKEY, SUM(NATION.N_NATIONKEY) FROM NATION GROUP BY NATION.N_NATIONKEY ORDER BY NATION.N_NATIONKEY ASC;