SELECT CUSTOMER.C_ADDRESS, ORDERS.O_CLERK FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY ORDER BY ORDERS.O_CLERK DESC, CUSTOMER.C_ADDRESS ASC;
