SELECT CUSTOMER.C_NAME, LINEITEM.L_DISCOUNT, ORDERS.O_SHIPPRIORITY FROM LINEITEM, ORDERS, CUSTOMER ORDER BY CUSTOMER.C_NAME ASC;