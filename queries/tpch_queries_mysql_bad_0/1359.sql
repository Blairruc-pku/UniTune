SELECT REGION.R_REGIONKEY, NATION.N_REGIONKEY, COUNT(NATION.N_REGIONKEY) FROM REGION, NATION GROUP BY REGION.R_REGIONKEY, NATION.N_REGIONKEY HAVING COUNT(NATION.N_REGIONKEY) <= 8;
