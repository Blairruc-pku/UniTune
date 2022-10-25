SELECT PART.P_BRAND, PARTSUPP.PS_SUPPKEY, MIN(PART.P_SIZE) FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY WHERE PARTSUPP.PS_AVAILQTY < 2103 AND PART.P_RETAILPRICE > 910.01 GROUP BY PART.P_BRAND, PARTSUPP.PS_SUPPKEY ORDER BY MIN(PART.P_SIZE) DESC;
