SELECT PARTSUPP.PS_SUPPLYCOST, PART.P_CONTAINER FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY;