SELECT ORDERS.O_TOTALPRICE, AVG(ORDERS.O_SHIPPRIORITY) FROM ORDERS GROUP BY ORDERS.O_TOTALPRICE;
