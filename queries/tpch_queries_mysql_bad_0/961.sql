SELECT LINEITEM.L_LINENUMBER, ORDERS.O_COMMENT, CUSTOMER.C_PHONE FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY;