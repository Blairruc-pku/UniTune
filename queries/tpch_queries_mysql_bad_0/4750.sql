SELECT PART.P_NAME, PARTSUPP.PS_COMMENT, SUM(PARTSUPP.PS_AVAILQTY) FROM PARTSUPP, PART WHERE PART.P_NAME >= 'BURNISHED PUFF CORAL LIGHT PAPAYA' GROUP BY PART.P_NAME, PARTSUPP.PS_COMMENT HAVING SUM(PARTSUPP.PS_AVAILQTY) < 2467 ORDER BY SUM(PARTSUPP.PS_AVAILQTY) DESC;