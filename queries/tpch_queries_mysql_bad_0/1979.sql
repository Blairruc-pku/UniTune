SELECT ORDERS.O_TOTALPRICE, CUSTOMER.C_PHONE, LINEITEM.L_SHIPDATE FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY;
