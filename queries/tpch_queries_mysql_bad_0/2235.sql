SELECT PART.P_SIZE, SUM(PART.P_PARTKEY) FROM PART WHERE PART.P_COMMENT <= 'OLE AGAINST THE' GROUP BY PART.P_SIZE HAVING SUM(PART.P_PARTKEY) <= 95 ORDER BY PART.P_SIZE DESC;
