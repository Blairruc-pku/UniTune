SELECT NATION.N_NATIONKEY, REGION.R_COMMENT, COUNT(REGION.R_COMMENT) FROM NATION, REGION WHERE REGION.R_NAME <= 'CLERK#000000955' GROUP BY NATION.N_NATIONKEY, REGION.R_COMMENT;
