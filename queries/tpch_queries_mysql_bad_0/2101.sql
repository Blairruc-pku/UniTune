SELECT REGION.R_COMMENT, CUSTOMER.C_MKTSEGMENT, NATION.N_NATIONKEY, COUNT(NATION.N_NAME) FROM REGION, NATION, CUSTOMER GROUP BY REGION.R_COMMENT, CUSTOMER.C_MKTSEGMENT, NATION.N_NATIONKEY;
