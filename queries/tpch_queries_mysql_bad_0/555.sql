SELECT ORDERS.O_ORDERKEY, NATION.N_REGIONKEY, CUSTOMER.C_PHONE FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY;
