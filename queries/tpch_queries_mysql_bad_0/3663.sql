SELECT SUPPLIER.S_NATIONKEY, CUSTOMER.C_PHONE, ORDERS.O_CUSTKEY, NATION.N_COMMENT FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY;
