SELECT NATION.N_REGIONKEY, CUSTOMER.C_PHONE, ORDERS.O_COMMENT FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY WHERE NATION.N_COMMENT = '1996-06-08';
