SELECT ORDERS.O_ORDERDATE, MIN(ORDERS.O_CLERK) FROM ORDERS GROUP BY ORDERS.O_ORDERDATE;
