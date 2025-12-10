/*1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a 
2014.*/
SELECT a.DNI, a.Legajo, p.Apellido, p.Nombre
FROM Alumno a
NATURAL JOIN Persona p
WHERE a.Anio_Ingreso < 2014

/*2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de 
100 horas de duración. Ordenar por DNI. */
SELECT p.DNI, p.Matricula, pe.Apellido, pe.Nombre
FROM Profesor p
NATURAL JOIN Persona pe
NATURAL JOIN Profesor_Curso pc
NATURAL JOIN Curso c
WHERE c.Duracion > 100
ORDER BY p.DNI

/*3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al 
curso con nombre “Diseño de Bases de Datos” en 2023. */
SELECT a.DNI, a.Legajo, p.Apellido, p.Nombre, p.Genero, p.Fecha_Nacimiento
FROM Alumno a
NATURAL JOIN Persona p
NATURAL JOIN Alumno_Curso ac
NATURAL JOIN Curso c
WHERE c.Nombre = 'Diseño de Bases de Datos' AND ac.Anio = 2023

/*4. Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una 
calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá 
estar ordenado por Apellido y nombre. */
SELECT DISTINCT a.DNI, a.Legajo, p.Apellido, p.Nombre, ac.Calificacion
FROM Alumno a
NATURAL JOIN Persona p
NATURAL JOIN Alumno_Curso ac
WHERE ac.Calificacion > 8 
AND (ac.Cod_Curso IN (
SELECT pc.Cod_Curso
FROM Profesor_Curso pc
NATURAL JOIN Profesor pr
NATURAL JOIN Persona pp
WHERE pp.Nombre = 'Juan' AND pp.Apellido = 'Garcia'
))

/*5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos. 
Dicho listado deberá estar ordenado por Apellido y Nombre. */
SELECT p.DNI, pe.Apellido, pe.Nombre, p.Matricula
FROM Profesor p
NATURAL JOIN Persona pe
NATURAL JOIN Titulo_Profesor tp
GROUP BY p.DNI, pe.Apellido, pe.Nombre, p.Matricula
HAVING COUNT(tp.Cod_Titulo) > 3
ORDER BY pe.Apellido, pe.Nombre

/*6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor. 
La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta.  */
SELECT p.DNI, pe.Apellido, pe.Nombre, SUM(c.Duracion) AS CantHoras, AVG(c.Duracion) AS PromedioHoras
FROM Profesor p
NATURAL JOIN Persona pe
LEFT JOIN Profesor_Curso pc ON pc.DNI = pe.DNI
LEFT JOIN Curso c ON c.Cod_Curso = pc.Cod_Curso
GROUP BY p.DNI, pe.Apellido, pe.Nombre

/*7. Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea 
menos alumnos inscriptos durante 2024.
NO SE COM HACERLO :/ */

/*8. Listar el DNI, Apellido, Nombre y Legajo de alumnos que realizaron cursos con nombre 
conteniendo el string ‘BD’ durante 2022 pero no realizaron ningún curso durante 2023. */
SELECT a.DNI, a.Legajo, p.Apellido, p.Nombre
FROM Alumno a
INNER JOIN Persona p ON p.DNI = a.DNI
INNER JOIN Alumno_Curso ac ON ac.DNI = a.DNI
INNER JOIN Curso c ON c.Cod_Curso = ac.Cod_Curso
WHERE c.Nombre LIKE '%BD%'
AND ac.Anio = 2022
AND (a.DNI NOT IN (
SELECT a.DNI
WHERE ac.Anio = 2023
))

/*9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25.*/
INSERT INTO Persona (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
VALUES (45000000, 'Perez', 'Mariana', '1995-05-15', 'Soltera', 'F');

INSERT INTO Profesor (DNI, Matricula, Nro_Expediente)
VALUES (45000000, 'PR-900', 9000);

INSERT INTO Titulo_Profesor (Cod_Titulo, DNI, Fecha)
VALUES (25, 45000000, DATE('now'));

/*10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es divorciado.*/
UPDATE Persona SET Estado_Civil = 'Divorciado'
WHERE DNI IN (
SELECT DNI
FROM Alumno
WHERE Legajo = '2020/09'
) 