SELECT LINEITEM.L_LINESTATUS, PARTSUPP.PS_PARTKEY FROM PARTSUPP, LINEITEM WHERE LINEITEM.L_ORDERKEY <= 4389;