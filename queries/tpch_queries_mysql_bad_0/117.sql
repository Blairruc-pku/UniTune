SELECT ORDERS.O_ORDERKEY, CUSTOMER.C_ACCTBAL FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY WHERE ORDERS.O_COMMENT <= 'DEPOSITS ACCORDING TO THE CAREFULL';