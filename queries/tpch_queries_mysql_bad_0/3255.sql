SELECT LINEITEM.L_COMMITDATE, COUNT(LINEITEM.L_LINENUMBER), SUM(LINEITEM.L_QUANTITY) FROM LINEITEM GROUP BY LINEITEM.L_COMMITDATE;
