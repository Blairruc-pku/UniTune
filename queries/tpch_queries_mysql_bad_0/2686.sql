SELECT LINEITEM.L_QUANTITY, MIN(LINEITEM.L_LINENUMBER) FROM LINEITEM WHERE LINEITEM.L_RETURNFLAG >= 'N' GROUP BY LINEITEM.L_QUANTITY HAVING MIN(LINEITEM.L_LINENUMBER) >= 3;
