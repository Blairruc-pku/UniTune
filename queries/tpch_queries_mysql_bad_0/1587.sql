SELECT NATION.N_NATIONKEY, COUNT(NATION.N_REGIONKEY) FROM NATION GROUP BY NATION.N_NATIONKEY HAVING COUNT(NATION.N_REGIONKEY) >= 1 ORDER BY COUNT(NATION.N_REGIONKEY) ASC;
