SELECT NATION.N_REGIONKEY, MAX(NATION.N_COMMENT) FROM NATION GROUP BY NATION.N_REGIONKEY HAVING MAX(NATION.N_COMMENT) = 'ORDERS';
