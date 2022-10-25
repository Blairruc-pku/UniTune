SELECT LINEITEM.L_SHIPDATE, PART.P_BRAND, PARTSUPP.PS_SUPPKEY, SUM(PARTSUPP.PS_AVAILQTY) FROM PART, PARTSUPP, LINEITEM GROUP BY LINEITEM.L_SHIPDATE, PART.P_BRAND, PARTSUPP.PS_SUPPKEY ORDER BY PART.P_BRAND DESC, LINEITEM.L_SHIPDATE ASC, PARTSUPP.PS_SUPPKEY ASC;
