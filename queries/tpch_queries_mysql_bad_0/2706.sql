SELECT SUPPLIER.S_ADDRESS, LINEITEM.L_SHIPDATE, PARTSUPP.PS_SUPPLYCOST, ORDERS.O_CUSTKEY FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY WHERE LINEITEM.L_TAX < 0.03 ORDER BY SUPPLIER.S_ADDRESS ASC, PARTSUPP.PS_SUPPLYCOST DESC, ORDERS.O_CUSTKEY ASC, LINEITEM.L_SHIPDATE DESC;
