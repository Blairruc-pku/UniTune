SELECT LINEITEM.L_DISCOUNT, ORDERS.O_ORDERKEY, MAX(LINEITEM.L_PARTKEY), MAX(LINEITEM.L_RECEIPTDATE) FROM LINEITEM, ORDERS GROUP BY LINEITEM.L_DISCOUNT, ORDERS.O_ORDERKEY ORDER BY LINEITEM.L_DISCOUNT ASC, ORDERS.O_ORDERKEY ASC;
