SELECT PARTSUPP.PS_PARTKEY, LINEITEM.L_LINESTATUS, PART.P_SIZE FROM PART, PARTSUPP, LINEITEM ORDER BY PART.P_SIZE DESC;
