SELECT ORDERS.O_CUSTKEY, CUSTOMER.C_NATIONKEY FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY WHERE ORDERS.O_ORDERSTATUS <= 'O' ORDER BY ORDERS.O_CUSTKEY DESC;
