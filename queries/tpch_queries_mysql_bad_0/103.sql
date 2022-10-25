SELECT NATION.N_NATIONKEY, REGION.R_COMMENT, MAX(REGION.R_COMMENT) FROM REGION, NATION WHERE REGION.R_NAME > '12052.90' GROUP BY NATION.N_NATIONKEY, REGION.R_COMMENT HAVING MAX(REGION.R_COMMENT) <= 'REGION';
