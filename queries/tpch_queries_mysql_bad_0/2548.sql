SELECT ORDERS.O_SHIPPRIORITY, CUSTOMER.C_ADDRESS FROM ORDERS, CUSTOMER WHERE CUSTOMER.C_PHONE >= '11-717-379-4478' AND CUSTOMER.C_PHONE > '22-291-534-1571' AND CUSTOMER.C_NAME != 'CUSTOMER#000000136' ORDER BY CUSTOMER.C_ADDRESS ASC, ORDERS.O_SHIPPRIORITY DESC;