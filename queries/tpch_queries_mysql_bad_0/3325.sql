SELECT CUSTOMER.C_MKTSEGMENT, NATION.N_NAME, REGION.R_NAME FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY ORDER BY CUSTOMER.C_MKTSEGMENT DESC;
