SELECT NATION.N_NAME, MAX(NATION.N_NAME) FROM NATION GROUP BY NATION.N_NAME ORDER BY NATION.N_NAME ASC;
