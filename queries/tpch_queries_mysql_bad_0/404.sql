SELECT CUSTOMER.C_NAME, ORDERS.O_CUSTKEY FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY ORDER BY CUSTOMER.C_NAME DESC;
