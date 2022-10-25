SELECT ORDERS.O_ORDERPRIORITY, LINEITEM.L_RECEIPTDATE, PARTSUPP.PS_AVAILQTY FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY WHERE LINEITEM.L_LINENUMBER < 2 ORDER BY ORDERS.O_ORDERPRIORITY ASC;
