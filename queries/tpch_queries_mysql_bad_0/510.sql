SELECT ORDERS.O_COMMENT, SUM(ORDERS.O_ORDERKEY), COUNT(ORDERS.O_ORDERKEY) FROM ORDERS GROUP BY ORDERS.O_COMMENT;
