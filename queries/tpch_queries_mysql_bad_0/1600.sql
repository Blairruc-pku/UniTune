SELECT ORDERS.O_CLERK, CUSTOMER.C_NAME FROM ORDERS, CUSTOMER WHERE ORDERS.O_SHIPPRIORITY > 0 ORDER BY CUSTOMER.C_NAME DESC, ORDERS.O_CLERK DESC;
