SELECT ORDERS.O_COMMENT, MAX(ORDERS.O_COMMENT) FROM ORDERS GROUP BY ORDERS.O_COMMENT;