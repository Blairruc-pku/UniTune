SELECT LINEITEM.L_DISCOUNT, ORDERS.O_SHIPPRIORITY FROM ORDERS, LINEITEM ORDER BY ORDERS.O_SHIPPRIORITY ASC, LINEITEM.L_DISCOUNT ASC;