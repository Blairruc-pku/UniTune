SELECT ORDERS.O_CLERK, CUSTOMER.C_COMMENT FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE ORDERS.O_CLERK <= 'CLERK#000000567';