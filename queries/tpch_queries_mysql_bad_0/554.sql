SELECT LINEITEM.L_SHIPDATE, PARTSUPP.PS_PARTKEY, ORDERS.O_ORDERPRIORITY FROM ORDERS, LINEITEM, PARTSUPP WHERE LINEITEM.L_LINESTATUS <= 'F' AND LINEITEM.L_LINENUMBER > 5 AND LINEITEM.L_COMMENT > 'IOUSLY SLYLY';
