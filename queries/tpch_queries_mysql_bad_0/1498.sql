SELECT LINEITEM.L_QUANTITY, PARTSUPP.PS_COMMENT, ORDERS.O_ORDERKEY, SUPPLIER.S_ADDRESS FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY;
