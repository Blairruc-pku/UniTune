SELECT SUPPLIER.S_COMMENT, NATION.N_COMMENT, ORDERS.O_SHIPPRIORITY, CUSTOMER.C_MKTSEGMENT FROM SUPPLIER, NATION, CUSTOMER, ORDERS ORDER BY CUSTOMER.C_MKTSEGMENT DESC, SUPPLIER.S_COMMENT ASC;