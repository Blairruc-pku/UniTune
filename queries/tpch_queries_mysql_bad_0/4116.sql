SELECT LINEITEM.L_LINENUMBER, MIN(LINEITEM.L_ORDERKEY) FROM LINEITEM GROUP BY LINEITEM.L_LINENUMBER;
