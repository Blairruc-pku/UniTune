SELECT PARTSUPP.PS_AVAILQTY, LINEITEM.L_QUANTITY, PART.P_NAME FROM PART, PARTSUPP, LINEITEM WHERE LINEITEM.L_RETURNFLAG > 'A' ORDER BY LINEITEM.L_QUANTITY DESC, PARTSUPP.PS_AVAILQTY DESC, PART.P_NAME ASC;
