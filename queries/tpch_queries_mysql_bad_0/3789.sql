SELECT LINEITEM.L_LINENUMBER, PARTSUPP.PS_PARTKEY, MIN(PARTSUPP.PS_PARTKEY) FROM LINEITEM, PARTSUPP GROUP BY LINEITEM.L_LINENUMBER, PARTSUPP.PS_PARTKEY ORDER BY PARTSUPP.PS_PARTKEY DESC;
