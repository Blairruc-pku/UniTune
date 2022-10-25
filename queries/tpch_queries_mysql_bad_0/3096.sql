SELECT PARTSUPP.PS_PARTKEY, ORDERS.O_ORDERDATE, LINEITEM.L_RECEIPTDATE, MAX(LINEITEM.L_TAX) FROM ORDERS, LINEITEM, PARTSUPP GROUP BY PARTSUPP.PS_PARTKEY, ORDERS.O_ORDERDATE, LINEITEM.L_RECEIPTDATE HAVING MAX(LINEITEM.L_TAX) > 0.07 ORDER BY ORDERS.O_ORDERDATE ASC;
