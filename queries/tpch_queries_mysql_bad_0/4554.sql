SELECT LINEITEM.L_RETURNFLAG, ORDERS.O_ORDERDATE, MAX(LINEITEM.L_PARTKEY) FROM ORDERS, LINEITEM GROUP BY LINEITEM.L_RETURNFLAG, ORDERS.O_ORDERDATE HAVING MAX(LINEITEM.L_PARTKEY) = 11899;
