SELECT CUSTOMER.C_ADDRESS, ORDERS.O_ORDERPRIORITY, NATION.N_NATIONKEY FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY ORDER BY CUSTOMER.C_ADDRESS ASC;
