SELECT CUSTOMER.C_MKTSEGMENT, ORDERS.O_TOTALPRICE, NATION.N_NAME, MAX(CUSTOMER.C_ADDRESS), AVG(NATION.N_REGIONKEY) FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY GROUP BY CUSTOMER.C_MKTSEGMENT, ORDERS.O_TOTALPRICE, NATION.N_NAME ORDER BY CUSTOMER.C_MKTSEGMENT DESC, NATION.N_NAME DESC;
