SELECT ORDERS.O_CLERK, LINEITEM.L_TAX, AVG(LINEITEM.L_ORDERKEY) FROM LINEITEM, ORDERS GROUP BY ORDERS.O_CLERK, LINEITEM.L_TAX ORDER BY LINEITEM.L_TAX DESC;
