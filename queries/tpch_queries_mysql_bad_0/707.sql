SELECT LINEITEM.L_EXTENDEDPRICE, ORDERS.O_TOTALPRICE, CUSTOMER.C_NAME FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY ORDER BY ORDERS.O_TOTALPRICE ASC, LINEITEM.L_EXTENDEDPRICE ASC, CUSTOMER.C_NAME DESC;