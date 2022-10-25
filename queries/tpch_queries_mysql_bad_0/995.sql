SELECT ORDERS.O_ORDERPRIORITY, LINEITEM.L_RETURNFLAG, COUNT(ORDERS.O_ORDERDATE) FROM LINEITEM, ORDERS GROUP BY ORDERS.O_ORDERPRIORITY, LINEITEM.L_RETURNFLAG ORDER BY COUNT(ORDERS.O_ORDERDATE) ASC;
