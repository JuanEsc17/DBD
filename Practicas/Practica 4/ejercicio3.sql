/*1. Listar DNI, nombre, apellido,dirección y email de integrantes nacidos entre 1980 y 1990 y que 
hayan realizado algún recital durante 2023. */
SELECT i.DNI, i.nombre, i.apellido, i.direccion, i.email
FROM Integrante i
WHERE YEAR(i.fecha_nacimiento) >= 1980 AND YEAR(i.fecha_nacimiento) <= 1990
AND (i.DNI IN (
SELECT i.DNI
FROM Integrante i 
NATURAL JOIN Banda b
NATURAL JOIN Recital r
WHERE YEAR(r.fecha) = 2023
))

/*2. Reportar nombre, género musical y año de creación de bandas que hayan realizado recitales 
durante 2023, pero no hayan tocado durante 2022 . */
SELECT DISTINCT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
INNER JOIN Recital r ON r.codigoB = b.codigoB
WHERE YEAR(r.fecha) = 2023
AND (b.codigoB NOT IN (
SELECT b.codigoB
WHERE YEAR(r.fecha) = 2022
))

/*3. Listar el cronograma de recitales del día 04/12/2023. Se deberá listar nombre de la banda que 
ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente. */
SELECT b.nombreBanda, r.fecha, r.hora, e.nombre_escenario, e.ubicacion
FROM Recital r
NATURAL JOIN Banda b
NATURAL JOIN Escenario e
WHERE fecha = '2023-12-04'

/*4. Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con nombre 
‘Gustavo Cerati’ y en el escenario  con nombre ‘Carlos Gardel’. */
SELECT DISTINCT  i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
NATURAL JOIN Banda b
NATURAL JOIN Recital r
NATURAL JOIN Escenario e  
WHERE (e.nombre_escenario = 'Gustavo Cerati')
INTERSECT
SELECT DISTINCT  i.DNI, i.nombre, i.apellido, i.email
FROM Integrante i
NATURAL JOIN Banda b
NATURAL JOIN Recital r
NATURAL JOIN Escenario e  
WHERE (e.nombre_escenario = 'Carlos Gardel')

/*5. Reportar nombre, género musical y año de creación de bandas que tengan más de 5 integrantes.  */
SELECT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
NATURAL JOIN Integrante i
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.anio_creacion
HAVING COUNT(*) > 5

/*6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron recitales 
con el género musical rock and roll. Ordenar por nombre de escenario*/
SELECT e.nombre_escenario, e.ubicacion, e.descripcion
FROM Escenario e
INNER JOIN Recital r ON (r.nroEscenario = e.nroEscenario)
INNER JOIN Banda b ON (b.codigoB = r.codigoB)
WHERE (e.nroEscenario NOT IN (
SELECT e.nroEscenario
WHERE b.genero_musical <> 'Rock And Roll'
))
ORDER BY e.nombre_escenario

/*7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales en 
escenarios cubiertos durante 2023.// cubierto es true, false según corresponda */
SELECT DISTINCT b.nombreBanda, b.genero_musical, b.anio_creacion
FROM Banda b
NATURAL JOIN Recital r
NATURAL JOIN Escenario e
WHERE e.cubierto AND YEAR(r.fecha) = 2023

/*8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2024. */
SELECT e.nombre_escenario, COUNT(r.fecha) AS CantRecitales2024
FROM Escenario e 
LEFT JOIN Recital r ON r.nroEscenario = e.nroEscenario
WHERE YEAR(r.fecha) = 2024
GROUP BY e.nroEscenario, e.nombre_escenario

/*9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’*/
UPDATE Banda 
SET nombreBanda = 'Memphis la Blusera'
WHERE nombreBanda = 'Mempis la Blusera'