SELECT ORDERS.O_SHIPPRIORITY, CUSTOMER.C_NAME, LINEITEM.L_DISCOUNT, PARTSUPP.PS_SUPPLYCOST FROM CUSTOMER, ORDERS, LINEITEM, PARTSUPP WHERE ORDERS.O_ORDERPRIORITY < '1-URGENT       ' ORDER BY ORDERS.O_SHIPPRIORITY ASC, LINEITEM.L_DISCOUNT DESC;
