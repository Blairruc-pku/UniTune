SELECT LINEITEM.L_RECEIPTDATE, AVG(LINEITEM.L_EXTENDEDPRICE), SUM(LINEITEM.L_SUPPKEY) FROM LINEITEM GROUP BY LINEITEM.L_RECEIPTDATE ORDER BY LINEITEM.L_RECEIPTDATE DESC;
