SELECT LINEITEM.L_EXTENDEDPRICE, ORDERS.O_ORDERSTATUS, MIN(ORDERS.O_ORDERDATE) FROM LINEITEM, ORDERS GROUP BY LINEITEM.L_EXTENDEDPRICE, ORDERS.O_ORDERSTATUS ORDER BY MIN(ORDERS.O_ORDERDATE) DESC;