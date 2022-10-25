SELECT ORDERS.O_CLERK, LINEITEM.L_LINESTATUS, MAX(LINEITEM.L_SHIPMODE) FROM LINEITEM, ORDERS GROUP BY ORDERS.O_CLERK, LINEITEM.L_LINESTATUS HAVING MAX(LINEITEM.L_SHIPMODE) >= 'SHIP      ';
