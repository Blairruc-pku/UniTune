SELECT LINEITEM.L_EXTENDEDPRICE, ORDERS.O_ORDERDATE, MAX(LINEITEM.L_RECEIPTDATE) FROM LINEITEM, ORDERS GROUP BY LINEITEM.L_EXTENDEDPRICE, ORDERS.O_ORDERDATE ORDER BY MAX(LINEITEM.L_RECEIPTDATE) ASC;
