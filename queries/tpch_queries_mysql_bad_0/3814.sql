SELECT CUSTOMER.C_MKTSEGMENT, ORDERS.O_ORDERSTATUS, MIN(CUSTOMER.C_ADDRESS) FROM ORDERS, CUSTOMER GROUP BY CUSTOMER.C_MKTSEGMENT, ORDERS.O_ORDERSTATUS HAVING MIN(CUSTOMER.C_ADDRESS) != 'JD2XZZI UMID,DCTNBLXKJ9Q0TLP2IQ6ZCO3J';
