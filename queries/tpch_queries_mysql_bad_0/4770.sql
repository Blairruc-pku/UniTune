SELECT ORDERS.O_ORDERPRIORITY, CUSTOMER.C_ACCTBAL, LINEITEM.L_SHIPMODE FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY;