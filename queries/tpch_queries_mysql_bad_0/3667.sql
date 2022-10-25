SELECT ORDERS.O_TOTALPRICE, CUSTOMER.C_PHONE FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE CUSTOMER.C_CUSTKEY <= 64 AND ORDERS.O_ORDERPRIORITY >= '3-MEDIUM       ' ORDER BY CUSTOMER.C_PHONE DESC;
