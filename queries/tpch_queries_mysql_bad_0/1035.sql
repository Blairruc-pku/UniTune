SELECT CUSTOMER.C_PHONE, ORDERS.O_TOTALPRICE, MIN(ORDERS.O_ORDERSTATUS) FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY GROUP BY CUSTOMER.C_PHONE, ORDERS.O_TOTALPRICE HAVING MIN(ORDERS.O_ORDERSTATUS) > 'O';
