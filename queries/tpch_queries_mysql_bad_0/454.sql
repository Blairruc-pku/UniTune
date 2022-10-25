SELECT SUPPLIER.S_SUPPKEY, CUSTOMER.C_COMMENT, LINEITEM.L_DISCOUNT, ORDERS.O_TOTALPRICE, PARTSUPP.PS_SUPPKEY, AVG(SUPPLIER.S_ACCTBAL) FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY GROUP BY SUPPLIER.S_SUPPKEY, CUSTOMER.C_COMMENT, LINEITEM.L_DISCOUNT, ORDERS.O_TOTALPRICE, PARTSUPP.PS_SUPPKEY ORDER BY ORDERS.O_TOTALPRICE DESC, SUPPLIER.S_SUPPKEY ASC, PARTSUPP.PS_SUPPKEY DESC, CUSTOMER.C_COMMENT DESC;