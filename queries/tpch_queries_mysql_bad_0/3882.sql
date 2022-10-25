SELECT ORDERS.O_CUSTKEY, MIN(ORDERS.O_COMMENT), MIN(ORDERS.O_ORDERSTATUS) FROM ORDERS GROUP BY ORDERS.O_CUSTKEY HAVING MIN(ORDERS.O_COMMENT) > 'UICKLY EXPRESS FOXES HAGGLE QUICKLY AGAINST' AND MIN(ORDERS.O_ORDERSTATUS) < 'O' ORDER BY ORDERS.O_CUSTKEY DESC;