SELECT CUSTOMER.C_CUSTKEY, ORDERS.O_SHIPPRIORITY, COUNT(ORDERS.O_CUSTKEY) FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY GROUP BY CUSTOMER.C_CUSTKEY, ORDERS.O_SHIPPRIORITY;
