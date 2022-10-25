SELECT LINEITEM.L_PARTKEY, ORDERS.O_TOTALPRICE, PARTSUPP.PS_AVAILQTY, MAX(ORDERS.O_CUSTKEY) FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY GROUP BY LINEITEM.L_PARTKEY, ORDERS.O_TOTALPRICE, PARTSUPP.PS_AVAILQTY ORDER BY MAX(ORDERS.O_CUSTKEY) ASC;
