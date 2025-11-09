/* 1. Listar especie, años, calle, nro y localidad de árboles podados por el podador ‘Juan Perez’ y por 
el podador ‘Jose Garcia’.  */
(SELECT DISTINCT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Poda pod
INNER JOIN Podador p ON pod.DNI = p.DNI
INNER JOIN Arbol a ON a.nroArbol = pod.nroArbol
INNER JOIN Localidad l ON l.codigoPostal = a.codigoPostal
WHERE (p.nombre = 'Jose' AND p.apellido = 'Garcia'))
INTERSECT
(SELECT DISTINCT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Poda pod
INNER JOIN Podador p ON pod.DNI = p.DNI
INNER JOIN Arbol a ON a.nroArbol = pod.nroArbol
INNER JOIN Localidad l ON l.codigoPostal = a.codigoPostal
WHERE (p.nombre = 'Juan' AND p.apellido = 'Perez'))

/*2. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos 
podadores que tengan podas realizadas durante 2023.  */
SELECT DISTINCT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL 
FROM Podador p
INNER JOIN Localidad l ON (l.codigoPostal = p.codigoPostalVive)
INNER JOIN Poda pod ON (pod.DNI = p.DNI)
WHERE (pod.fecha LIKE '2023%')

/*3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca. */
SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL
FROM Arbol a
INNER JOIN Localidad l ON l.codigoPostal = a.codigoPostal
WHERE (a.nroArbol NOT IN (
SELECT p.nroArbol
FROM Poda p
))

/*4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2022 y  no 
fueron podados durante 2023. */
SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL 
FROM Poda p 
INNER JOIN Arbol a ON (p.nroArbol = a.nroArbol) 
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal) 
WHERE (p.fecha LIKE '2022%') 
EXCEPT 
SELECT a.especie, a.anios, a.calle, a.nro, l.nombreL 
FROM Poda p 
INNER JOIN Arbol a ON (p.nroArbol = a.nroArbol) 
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal) 
WHERE (p.fecha LIKE '2023%')

/*5. Reportar DNI, nombre, apellido, fecha de nacimiento y localidad donde viven de aquellos 
podadores con apellido terminado con el string ‘ata’  y que tengan al menos una poda durante 
2024. Ordenar por apellido y nombre. */
SELECT DISTINCT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL 
FROM Podador p
INNER JOIN Localidad l ON (l.codigoPostal = p.codigoPostalVive)
INNER JOIN Poda pod ON (pod.DNI = p.DNI)
WHERE p.apellido LIKE '%ata' AND pod.DNI IN (
SELECT pod.DNI
FROM Podador p
INNER JOIN Poda pod ON (pod.DNI = p.DNI)
WHERE pod.fecha LIKE '2024%'
)
ORDER BY p.apellido, p.nombre

/*6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron 
árboles de especie ‘Coníferas’.*/
SELECT p.DNI, p.nombre, p.apellido, p.fnac, p.telefono
FROM Podador p
INNER JOIN Poda pod ON (pod.DNI = p.DNI)
INNER JOIN Arbol a ON (pod.nroArbol = a.nroArbol)
WHERE a.especie = 'Conífera'
EXCEPT
SELECT p.DNI, p.nombre, p.apellido, p.fnac, p.telefono
FROM Podador p
INNER JOIN Poda pod ON (pod.DNI = p.DNI)
INNER JOIN Arbol a ON (pod.nroArbol = a.nroArbol)
WHERE a.especie <> 'Conífera'

/*7. Listar especies de árboles que se encuentren en la localidad de ‘La Plata’ y también en la 
localidad de ‘Salta’. */
SELECT DISTINCT a.especie
FROM Poda p 
INNER JOIN Arbol a ON (p.nroArbol = a.nroArbol) 
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal) 
WHERE (l.nombreL = 'La Plata') AND (a.especie IN (
SELECT a.especie
FROM Poda p 
INNER JOIN Arbol a ON (p.nroArbol = a.nroArbol) 
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal) 
WHERE (l.nombreL = 'Salta')
))

/*8. Eliminar el podador con DNI 22234566. */
DELETE FROM Poda WHERE (DNI = 22234566) 
DELETE FROM Podador WHERE (DNI = 22234566)

/*9. Reportar  nombre, descripción y cantidad de habitantes de localidades que tengan menos de 5 
árboles.  */
SELECT l.nombreL, l.descripcion, l.nroHabitantes
FROM Localidad l
INNER JOIN Arbol a ON l.codigoPostal = a.codigoPostal
GROUP BY l.codigoPostal
HAVING COUNT(a.nroArbol) < 5
