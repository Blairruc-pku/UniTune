SELECT NATION.N_NAME, COUNT(NATION.N_NATIONKEY) FROM NATION GROUP BY NATION.N_NAME HAVING COUNT(NATION.N_NATIONKEY) > 0;
