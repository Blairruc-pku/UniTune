SELECT NATION.N_NATIONKEY, REGION.R_REGIONKEY, COUNT(NATION.N_REGIONKEY) FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY GROUP BY NATION.N_NATIONKEY, REGION.R_REGIONKEY;
