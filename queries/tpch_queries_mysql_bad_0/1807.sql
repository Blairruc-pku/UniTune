SELECT LINEITEM.L_PARTKEY, ORDERS.O_COMMENT, PART.P_SIZE, PARTSUPP.PS_AVAILQTY FROM PART, PARTSUPP, LINEITEM, ORDERS;
