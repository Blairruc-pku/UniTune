SELECT ORDERS.O_TOTALPRICE, LINEITEM.L_TAX FROM ORDERS, LINEITEM ORDER BY ORDERS.O_TOTALPRICE ASC, LINEITEM.L_TAX DESC;