SELECT SUPPLIER.S_ACCTBAL, ORDERS.O_CLERK, LINEITEM.L_COMMITDATE, PARTSUPP.PS_COMMENT FROM ORDERS, LINEITEM, PARTSUPP, SUPPLIER ORDER BY ORDERS.O_CLERK DESC, LINEITEM.L_COMMITDATE ASC;
