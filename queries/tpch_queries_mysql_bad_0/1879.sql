SELECT LINEITEM.L_EXTENDEDPRICE, MAX(LINEITEM.L_RECEIPTDATE) FROM LINEITEM WHERE LINEITEM.L_COMMITDATE = '1997-07-05' GROUP BY LINEITEM.L_EXTENDEDPRICE;
