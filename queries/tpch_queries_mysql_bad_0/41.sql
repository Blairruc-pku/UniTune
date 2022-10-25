SELECT SUPPLIER.S_ADDRESS, NATION.N_REGIONKEY, CUSTOMER.C_NAME, ORDERS.O_CUSTKEY FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY ORDER BY ORDERS.O_CUSTKEY DESC;