SELECT NATION.N_NAME, ORDERS.O_CUSTKEY, CUSTOMER.C_CUSTKEY, MAX(ORDERS.O_CUSTKEY) FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY GROUP BY NATION.N_NAME, ORDERS.O_CUSTKEY, CUSTOMER.C_CUSTKEY ORDER BY ORDERS.O_CUSTKEY DESC, NATION.N_NAME DESC;