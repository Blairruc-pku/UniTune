SELECT CUSTOMER.C_COMMENT, ORDERS.O_CUSTKEY, LINEITEM.L_LINESTATUS, MIN(ORDERS.O_ORDERPRIORITY), MIN(CUSTOMER.C_ACCTBAL) FROM CUSTOMER, ORDERS, LINEITEM GROUP BY CUSTOMER.C_COMMENT, ORDERS.O_CUSTKEY, LINEITEM.L_LINESTATUS;
