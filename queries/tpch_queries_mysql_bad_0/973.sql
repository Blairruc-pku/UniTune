SELECT CUSTOMER.C_PHONE, ORDERS.O_CLERK FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE ORDERS.O_ORDERPRIORITY < '4-NOT SPECIFIED';
