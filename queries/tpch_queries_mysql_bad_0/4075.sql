SELECT LINEITEM.L_ORDERKEY, ORDERS.O_TOTALPRICE, PARTSUPP.PS_PARTKEY, SUPPLIER.S_ADDRESS FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY ORDER BY ORDERS.O_TOTALPRICE DESC, LINEITEM.L_ORDERKEY ASC;