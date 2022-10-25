SELECT LINEITEM.L_DISCOUNT, MIN(LINEITEM.L_EXTENDEDPRICE), MIN(LINEITEM.L_RETURNFLAG) FROM LINEITEM GROUP BY LINEITEM.L_DISCOUNT HAVING MIN(LINEITEM.L_RETURNFLAG) >= 'N';
