SELECT LINEITEM.L_SHIPMODE, AVG(LINEITEM.L_ORDERKEY) FROM LINEITEM GROUP BY LINEITEM.L_SHIPMODE ORDER BY AVG(LINEITEM.L_ORDERKEY) ASC;
