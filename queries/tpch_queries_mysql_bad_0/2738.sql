SELECT PART.P_SIZE, PARTSUPP.PS_PARTKEY, MIN(PART.P_NAME) FROM PART, PARTSUPP WHERE PART.P_MFGR = 'MANUFACTURER#1           ' GROUP BY PART.P_SIZE, PARTSUPP.PS_PARTKEY HAVING MIN(PART.P_NAME) >= 'FROSTED PERU CHIFFON YELLOW AQUAMARINE';
