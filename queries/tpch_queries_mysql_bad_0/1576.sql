SELECT LINEITEM.L_SUPPKEY, MIN(LINEITEM.L_EXTENDEDPRICE), MAX(LINEITEM.L_LINESTATUS) FROM LINEITEM GROUP BY LINEITEM.L_SUPPKEY;
