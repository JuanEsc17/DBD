/* 1.Listar datos personales de clientes cuyo apellido comience con el string ‘Pe’. Ordenar por DNI 
*/
SELECT * 
FROM Cliente 
WHERE apellido LIKE 'Pe%'
ORDER BY DNI

/* 2.Listar nombre, apellido, DNI, teléfono y dirección de clientes que realizaron compras solamente 
durante 2024.*/
SELECT c.nombre, c.apellido, c.DNI, c.telefono, c.direccion 
FROM Cliente c INNER JOIN Factura f ON (c.idCliente = f.idCliente)
WHERE f.fecha LIKE '2024%'

/*  3.Listar nombre, descripción, precio y stock de productos vendidos al cliente con DNI 45789456,  
pero que no fueron vendidos a clientes de apellido ‘Garcia’.  */
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p
INNER JOIN Detalle d ON (d.idProducto = p.idProducto)
INNER JOIN Factura f ON (f.nroTicket = d.nroTicket)
INNER JOIN Cliente c ON (c.idCliente = f.idCliente)
WHERE (c.DNI = 45789456)
EXCEPT
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p
INNER JOIN Detalle d ON (d.idProducto = p.idProducto)
INNER JOIN Factura f ON (f.nroTicket = d.nroTicket)
INNER JOIN Cliente c ON (c.idCliente = f.idCliente)
WHERE (c.apellido = 'Garcia')

/*4. Listar nombre, descripción, precio y stock de productos no vendidos a clientes que tengan 
teléfono con característica 221 (la característica está al comienzo del teléfono). Ordenar por 
nombre.  */
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM Producto p
WHERE p.idProducto NOT IN (
SELECT p.idProducto
FROM Producto p
INNER JOIN Detalle d ON (d.idProducto = p.idProducto)
INNER JOIN Factura f ON (f.nroTicket = d.nroTicket)
INNER JOIN Cliente c ON (c.idCliente = f.idCliente)
WHERE (c.telefono LIKE '221%')
)
ORDER BY p.nombreP

/*5. Listar para cada producto nombre, descripción, precio y cuantas veces fue vendido. Tenga en 
cuenta que puede no haberse vendido nunca el producto.   */
