SELECT PART.P_CONTAINER, PARTSUPP.PS_PARTKEY FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY WHERE PARTSUPP.PS_PARTKEY > 150 ORDER BY PART.P_CONTAINER ASC;
