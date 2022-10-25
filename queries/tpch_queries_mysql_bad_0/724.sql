SELECT PARTSUPP.PS_PARTKEY, CUSTOMER.C_MKTSEGMENT, NATION.N_REGIONKEY, SUPPLIER.S_PHONE FROM PARTSUPP, SUPPLIER, NATION, CUSTOMER ORDER BY PARTSUPP.PS_PARTKEY DESC, SUPPLIER.S_PHONE DESC, CUSTOMER.C_MKTSEGMENT ASC;