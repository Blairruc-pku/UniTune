SELECT LINEITEM.L_DISCOUNT, MAX(LINEITEM.L_SHIPINSTRUCT) FROM LINEITEM GROUP BY LINEITEM.L_DISCOUNT;
