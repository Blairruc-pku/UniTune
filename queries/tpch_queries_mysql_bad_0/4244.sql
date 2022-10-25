SELECT CUSTOMER.C_NATIONKEY, ORDERS.O_COMMENT, LINEITEM.L_SUPPKEY, REGION.R_NAME, NATION.N_COMMENT, PARTSUPP.PS_SUPPLYCOST FROM PARTSUPP, LINEITEM, ORDERS, CUSTOMER, NATION, REGION WHERE PARTSUPP.PS_AVAILQTY = 5845 AND LINEITEM.L_LINENUMBER < 1 ORDER BY PARTSUPP.PS_SUPPLYCOST ASC, ORDERS.O_COMMENT DESC;
