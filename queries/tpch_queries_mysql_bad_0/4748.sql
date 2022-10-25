SELECT CUSTOMER.C_NATIONKEY, ORDERS.O_TOTALPRICE, AVG(ORDERS.O_SHIPPRIORITY) FROM ORDERS, CUSTOMER GROUP BY CUSTOMER.C_NATIONKEY, ORDERS.O_TOTALPRICE ORDER BY ORDERS.O_TOTALPRICE ASC, CUSTOMER.C_NATIONKEY DESC;
