SELECT PARTSUPP.PS_SUPPLYCOST, LINEITEM.L_TAX FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY;
