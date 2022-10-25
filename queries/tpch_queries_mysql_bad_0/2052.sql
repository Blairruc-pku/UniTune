SELECT PART.P_NAME, LINEITEM.L_TAX, ORDERS.O_ORDERSTATUS, PARTSUPP.PS_AVAILQTY FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY ORDER BY ORDERS.O_ORDERSTATUS DESC;