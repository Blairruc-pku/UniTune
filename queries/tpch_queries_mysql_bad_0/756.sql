SELECT LINEITEM.L_ORDERKEY, CUSTOMER.C_CUSTKEY, ORDERS.O_SHIPPRIORITY, MAX(LINEITEM.L_COMMENT) FROM LINEITEM, ORDERS, CUSTOMER GROUP BY LINEITEM.L_ORDERKEY, CUSTOMER.C_CUSTKEY, ORDERS.O_SHIPPRIORITY HAVING MAX(LINEITEM.L_COMMENT) = ' ACCOUNTS. CAREFULLY EVEN ';
