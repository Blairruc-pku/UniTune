SELECT NATION.N_NAME, CUSTOMER.C_CUSTKEY, ORDERS.O_ORDERPRIORITY, MAX(CUSTOMER.C_COMMENT) FROM NATION, CUSTOMER, ORDERS GROUP BY NATION.N_NAME, CUSTOMER.C_CUSTKEY, ORDERS.O_ORDERPRIORITY;
