SELECT ORDERS.O_CLERK, COUNT(ORDERS.O_ORDERPRIORITY) FROM ORDERS GROUP BY ORDERS.O_CLERK HAVING COUNT(ORDERS.O_ORDERPRIORITY) >= 6;
