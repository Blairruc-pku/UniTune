SELECT ORDERS.O_CLERK, CUSTOMER.C_COMMENT FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE CUSTOMER.C_ACCTBAL >= 8166.59 ORDER BY ORDERS.O_CLERK DESC, CUSTOMER.C_COMMENT DESC;
