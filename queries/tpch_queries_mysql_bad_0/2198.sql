SELECT LINEITEM.L_DISCOUNT, PARTSUPP.PS_SUPPLYCOST, MAX(LINEITEM.L_SUPPKEY) FROM PARTSUPP, LINEITEM WHERE LINEITEM.L_ORDERKEY = 4033 GROUP BY LINEITEM.L_DISCOUNT, PARTSUPP.PS_SUPPLYCOST ORDER BY PARTSUPP.PS_SUPPLYCOST ASC, LINEITEM.L_DISCOUNT DESC;
