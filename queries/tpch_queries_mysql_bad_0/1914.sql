SELECT ORDERS.O_ORDERSTATUS, MAX(ORDERS.O_SHIPPRIORITY) FROM ORDERS WHERE ORDERS.O_CUSTKEY > 13412 GROUP BY ORDERS.O_ORDERSTATUS HAVING MAX(ORDERS.O_SHIPPRIORITY) != 0 ORDER BY ORDERS.O_ORDERSTATUS DESC;