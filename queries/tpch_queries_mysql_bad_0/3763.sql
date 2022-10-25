SELECT LINEITEM.L_PARTKEY, PART.P_BRAND, ORDERS.O_COMMENT, CUSTOMER.C_NAME, PARTSUPP.PS_SUPPKEY, AVG(ORDERS.O_SHIPPRIORITY) FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY GROUP BY LINEITEM.L_PARTKEY, PART.P_BRAND, ORDERS.O_COMMENT, CUSTOMER.C_NAME, PARTSUPP.PS_SUPPKEY ORDER BY AVG(ORDERS.O_SHIPPRIORITY) ASC;
