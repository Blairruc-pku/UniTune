SELECT ORDERS.O_COMMENT, NATION.N_REGIONKEY, CUSTOMER.C_ACCTBAL, SUPPLIER.S_NAME FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY;