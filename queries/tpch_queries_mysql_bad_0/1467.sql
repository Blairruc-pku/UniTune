SELECT LINEITEM.L_SUPPKEY, PARTSUPP.PS_COMMENT, ORDERS.O_TOTALPRICE FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY WHERE ORDERS.O_CLERK != 'CLERK#000000660' ORDER BY ORDERS.O_TOTALPRICE DESC, PARTSUPP.PS_COMMENT DESC, LINEITEM.L_SUPPKEY DESC;