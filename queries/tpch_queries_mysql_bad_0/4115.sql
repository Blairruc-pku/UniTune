SELECT PARTSUPP.PS_SUPPLYCOST, PART.P_PARTKEY FROM PARTSUPP, PART WHERE PART.P_COMMENT != ' CAREFUL' AND PARTSUPP.PS_SUPPLYCOST >= 164.60 AND PART.P_COMMENT > 'NTS ARE CAREFULLY' AND PART.P_MFGR != 'MANUFACTURER#3           ' AND PARTSUPP.PS_SUPPLYCOST = 444.01;
