SELECT PARTSUPP.PS_SUPPLYCOST, PART.P_PARTKEY, LINEITEM.L_COMMITDATE, ORDERS.O_CLERK FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY;
