SELECT ORDERS.O_TOTALPRICE, MAX(ORDERS.O_CLERK), COUNT(ORDERS.O_ORDERKEY) FROM ORDERS GROUP BY ORDERS.O_TOTALPRICE ORDER BY COUNT(ORDERS.O_ORDERKEY) ASC;
