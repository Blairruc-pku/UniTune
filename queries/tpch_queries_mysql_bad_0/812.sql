SELECT PART.P_COMMENT, PARTSUPP.PS_PARTKEY FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY WHERE PART.P_COMMENT != ' PLATEL' AND PART.P_BRAND != 'BRAND#12  ';