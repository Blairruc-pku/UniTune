SELECT ORDERS.O_TOTALPRICE, CUSTOMER.C_COMMENT, MAX(CUSTOMER.C_NAME) FROM ORDERS, CUSTOMER GROUP BY ORDERS.O_TOTALPRICE, CUSTOMER.C_COMMENT;