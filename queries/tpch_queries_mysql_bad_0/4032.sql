SELECT ORDERS.O_SHIPPRIORITY, CUSTOMER.C_NATIONKEY FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY ORDER BY CUSTOMER.C_NATIONKEY DESC, ORDERS.O_SHIPPRIORITY DESC;
