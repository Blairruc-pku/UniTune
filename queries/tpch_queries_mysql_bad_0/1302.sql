SELECT CUSTOMER.C_COMMENT, ORDERS.O_ORDERSTATUS, NATION.N_NAME FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY;
