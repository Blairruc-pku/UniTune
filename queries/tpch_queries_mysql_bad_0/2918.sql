SELECT CUSTOMER.C_ACCTBAL, ORDERS.O_ORDERKEY FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE ORDERS.O_ORDERPRIORITY < '3-MEDIUM       ' ORDER BY CUSTOMER.C_ACCTBAL ASC, ORDERS.O_ORDERKEY ASC;