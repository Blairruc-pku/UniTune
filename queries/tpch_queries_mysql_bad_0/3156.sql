SELECT REGION.R_NAME, NATION.N_NATIONKEY, SUM(NATION.N_REGIONKEY) FROM REGION, NATION WHERE REGION.R_COMMENT != '5489.84' AND NATION.N_NAME = '36933.00' GROUP BY REGION.R_NAME, NATION.N_NATIONKEY;
