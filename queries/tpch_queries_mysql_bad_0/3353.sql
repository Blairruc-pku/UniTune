SELECT LINEITEM.L_RECEIPTDATE, PART.P_COMMENT, ORDERS.O_ORDERDATE, PARTSUPP.PS_SUPPKEY FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY;
