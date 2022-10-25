SELECT ORDERS.O_ORDERKEY, SUPPLIER.S_ADDRESS, NATION.N_NATIONKEY, CUSTOMER.C_ACCTBAL, MAX(SUPPLIER.S_ADDRESS) FROM ORDERS, CUSTOMER, NATION, SUPPLIER GROUP BY ORDERS.O_ORDERKEY, SUPPLIER.S_ADDRESS, NATION.N_NATIONKEY, CUSTOMER.C_ACCTBAL ORDER BY MAX(SUPPLIER.S_ADDRESS) DESC;