SELECT LINEITEM.L_EXTENDEDPRICE, PARTSUPP.PS_PARTKEY FROM LINEITEM, PARTSUPP WHERE LINEITEM.L_ORDERKEY <= 4931;