SELECT LINEITEM.L_SHIPDATE, CUSTOMER.C_ADDRESS, ORDERS.O_ORDERDATE FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY ORDER BY CUSTOMER.C_ADDRESS ASC, ORDERS.O_ORDERDATE ASC, LINEITEM.L_SHIPDATE DESC;