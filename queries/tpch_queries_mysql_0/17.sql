SELECT SUM(L_EXTENDEDPRICE) / 7.0 AS AVG_YEARLY FROM LINEITEM, PART WHERE P_PARTKEY = L_PARTKEY AND P_BRAND = 'BRAND#44' AND P_CONTAINER = 'WRAP PKG' AND L_QUANTITY < (SELECT 0.2 * AVG(L_QUANTITY) FROM LINEITEM WHERE L_PARTKEY = P_PARTKEY);
