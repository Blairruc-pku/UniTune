SELECT SUPPLIER.S_NAME, MAX(SUPPLIER.S_ADDRESS) FROM SUPPLIER GROUP BY SUPPLIER.S_NAME HAVING MAX(SUPPLIER.S_ADDRESS) >= 'SAYGAH3GYWMP72I PY';