SELECT ORDERS.O_SHIPPRIORITY, NATION.N_NAME, CUSTOMER.C_MKTSEGMENT, REGION.R_REGIONKEY, MIN(ORDERS.O_COMMENT), COUNT(NATION.N_NAME) FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY GROUP BY ORDERS.O_SHIPPRIORITY, NATION.N_NAME, CUSTOMER.C_MKTSEGMENT, REGION.R_REGIONKEY;