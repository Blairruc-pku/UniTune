SELECT LINEITEM.L_SUPPKEY, ORDERS.O_ORDERSTATUS, PART.P_COMMENT, PARTSUPP.PS_COMMENT FROM PART, PARTSUPP, LINEITEM, ORDERS;