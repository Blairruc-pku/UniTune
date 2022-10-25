SELECT LINEITEM.L_DISCOUNT, PARTSUPP.PS_AVAILQTY, SUM(PARTSUPP.PS_SUPPLYCOST) FROM LINEITEM, PARTSUPP GROUP BY LINEITEM.L_DISCOUNT, PARTSUPP.PS_AVAILQTY ORDER BY PARTSUPP.PS_AVAILQTY DESC;
