SELECT LINEITEM.L_SHIPMODE, CUSTOMER.C_ADDRESS, ORDERS.O_ORDERSTATUS, COUNT(ORDERS.O_ORDERSTATUS) FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY GROUP BY LINEITEM.L_SHIPMODE, CUSTOMER.C_ADDRESS, ORDERS.O_ORDERSTATUS ORDER BY COUNT(ORDERS.O_ORDERSTATUS) ASC;
