SELECT LINEITEM.L_LINENUMBER, PART.P_TYPE, PARTSUPP.PS_PARTKEY, MAX(PART.P_MFGR) FROM LINEITEM, PARTSUPP, PART GROUP BY LINEITEM.L_LINENUMBER, PART.P_TYPE, PARTSUPP.PS_PARTKEY;
