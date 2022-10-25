SELECT LINEITEM.L_RETURNFLAG, ORDERS.O_CUSTKEY, COUNT(ORDERS.O_ORDERDATE), MAX(ORDERS.O_ORDERPRIORITY), MAX(LINEITEM.L_ORDERKEY) FROM LINEITEM, ORDERS GROUP BY LINEITEM.L_RETURNFLAG, ORDERS.O_CUSTKEY HAVING MAX(LINEITEM.L_ORDERKEY) = 3591 ORDER BY COUNT(ORDERS.O_ORDERDATE) ASC, MAX(LINEITEM.L_ORDERKEY) ASC, MAX(ORDERS.O_ORDERPRIORITY) ASC;
