SELECT ORDERS.O_CUSTKEY, CUSTOMER.C_COMMENT FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE ORDERS.O_CLERK <= 'CLERK#000000859' AND ORDERS.O_ORDERPRIORITY < '3-MEDIUM       ';