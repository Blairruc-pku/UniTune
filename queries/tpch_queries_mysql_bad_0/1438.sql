SELECT PART.P_BRAND, MIN(PART.P_PARTKEY) FROM PART WHERE PART.P_MFGR != 'MANUFACTURER#2           ' GROUP BY PART.P_BRAND;
