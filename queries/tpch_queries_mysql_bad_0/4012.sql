SELECT LINEITEM.L_EXTENDEDPRICE, ORDERS.O_CUSTKEY, MAX(LINEITEM.L_SHIPDATE) FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY GROUP BY LINEITEM.L_EXTENDEDPRICE, ORDERS.O_CUSTKEY HAVING MAX(LINEITEM.L_SHIPDATE) > '1998-02-22';