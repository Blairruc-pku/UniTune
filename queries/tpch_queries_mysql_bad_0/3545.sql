SELECT CUSTOMER.C_ADDRESS, ORDERS.O_CUSTKEY, NATION.N_NATIONKEY FROM NATION, CUSTOMER, ORDERS ORDER BY ORDERS.O_CUSTKEY ASC;
