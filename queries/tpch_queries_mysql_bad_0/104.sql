SELECT PARTSUPP.PS_SUPPLYCOST, LINEITEM.L_EXTENDEDPRICE, PART.P_PARTKEY FROM PART, PARTSUPP, LINEITEM ORDER BY PARTSUPP.PS_SUPPLYCOST ASC;
