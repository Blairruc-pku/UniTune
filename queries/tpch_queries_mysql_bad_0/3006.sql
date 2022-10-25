SELECT LINEITEM.L_LINESTATUS, ORDERS.O_ORDERKEY, CUSTOMER.C_NATIONKEY, MAX(ORDERS.O_TOTALPRICE) FROM CUSTOMER, ORDERS, LINEITEM GROUP BY LINEITEM.L_LINESTATUS, ORDERS.O_ORDERKEY, CUSTOMER.C_NATIONKEY HAVING MAX(ORDERS.O_TOTALPRICE) != 31138.17;
