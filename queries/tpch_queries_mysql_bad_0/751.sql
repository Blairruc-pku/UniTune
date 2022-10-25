SELECT LINEITEM.L_TAX, PARTSUPP.PS_SUPPLYCOST, ORDERS.O_CLERK FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY WHERE LINEITEM.L_LINENUMBER != 3 ORDER BY PARTSUPP.PS_SUPPLYCOST DESC;
