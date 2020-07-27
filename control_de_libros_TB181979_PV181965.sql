use master;
DROP DATABASE IF EXISTS  [ Control_de_libros_TB181979]

CREATE DATABASE [ Control_de_libros_TB181979]
   go

use [ Control_de_libros_TB181979]

CREATE TABLE Editorial
	(
	Codigo varchar(4) PRIMARY KEY NOT NULL,
	Nombres text NOT NULL,
	Pais varchar(75) NOT NULL
	)
go

CREATE TABLE Ejemplar
	(
	Cod_libro varchar(4) NOT NULL,
	Ubicacion varchar(50) NOT NULL,
	Estado varchar(50) NOT NULL
	)
go

CREATE TABLE Autor_Libro
	(
	Cod_libro varchar(4) NOT NULL,
	Cod_autor varchar(4) NOT NULL
	)
go

CREATE TABLE Autor
	(
	Codigo varchar(4) PRIMARY KEY NOT NULL,
	Nombres text NOT NULL,
	Apellidos text NOT NULL,
	Nacionalidad varchar(100) NOT NULL
	)
go

CREATE TABLE Libro
	(
	Codigo varchar(4) PRIMARY KEY NOT NULL,
	Titulo varchar(200) NOT NULL,
	ISBN varchar(11) NOT NULL UNIQUE,
	Descripcion text NULL,
	Resumen text NULL,
	Annio_edicion int NOT NULL,
	Cod_editorial varchar(4) NOT NULL
	)
go

ALTER TABLE Libro
	ADD CONSTRAINT FK_libro_editorial
	FOREIGN KEY (Cod_editorial) 
	REFERENCES Editorial (Codigo);

ALTER TABLE Ejemplar
	ADD CONSTRAINT FK_libro_ejemplar
	FOREIGN KEY (Cod_libro) 
	REFERENCES Libro (Codigo);

ALTER TABLE Autor_Libro
	ADD CONSTRAINT FK_libro_libro
	FOREIGN KEY (Cod_libro)
	REFERENCES Libro (Codigo);

ALTER TABLE Autor_Libro
	ADD CONSTRAINT FK_autor_autor
	FOREIGN KEY (Cod_autor)
	REFERENCES Autor (Codigo);
go

INSERT Editorial
	VALUES	('ED01','Thomson internacional','Espana'),
			('ED02','Omega','Mexico'),
			('ED03','La fuente de la sabiduria','Colombia'),
			('ED04','Siglo XV','Espana');

INSERT Autor
	VALUES	('AU01','JOSE PEDRO','ALVARADO','ESPANOLA'),
			('AU02','MARIA TERESA','RIVAS','MEXICANO'),
			('AU03','JULIO CARLOS','FERNANDEZ','COLOMBIANO'),
			('AU04','ALEXANDER','RODRIGUEZ','MEXICANO'),
			('AU05','JUAN MIGUEL','ARTIGA','COLOMBIANO');

INSERT Libro
	VALUES	('LB01','Metodologia de la programacion','123-334-456','Sintaxis basicas de la programacion', '204 paginas',2000,'ED02'),
			('LB02','SQL Server 2005','345-678-076','Explicacion de las consultas SQL', '798 paginas',2005,'ED03'),
			('LB03','Como programar en C/C++','153-567-345','Diferencias entre C y C++', '156 paginas',1997,'ED02'),
			('LB04','Aprender PHP en 30 dias','234-345-987','Sintaxis PHP para crear paginas Web dinamicas', '200 paginas',2005,'ED01'),
			('LB05','SQL Server 2008','798-255-487','Administracion de base de datos', '150 paginas',2008,'ED03'),
			('LB06','CSS y HTML','652-414-111','Creacion de paginas web y hojas de estilo', '350 paginas',2007,'ED01');

INSERT Autor_Libro
	VALUES	('LB01','AU02'),
			('LB01','AU04'),
			('LB02','AU01'),
			('LB03','AU05'),
			('LB03','AU03'),
			('LB04','AU02'),
			('LB04','AU04');

INSERT Ejemplar
	VALUES	('LB01','Estante 1','Prestado'),
			('LB02','Estante 2','Disponible'),
			('LB02','Estante 2','Reservado'),
			('LB03','Estante 3','Prestado'),
			('LB04','Estante 4','Disponible'),
			('LB02','Estante 2','Reservado'),
			('LB04','Estante 4','Prestado'),
			('LB01','Estante 1','Disponible'),
			('LB02','Estante 2','Reservado'),
			('LB03','Estante 3','Prestado'),
			('LB01','Estante 1','Disponible'),
			('LB05','Estante 5','Disponible'),
			('LB06','Estante 5','Prestado'),
			('LB06','Estante 5','Disponible');

--a. Se desea mostrar los datos de los autores junto con los títulos de libros que han escrito.
--Ordenarlos en forma descendente por el nombre del autor

select Nombres,Apellidos,Nacionalidad, li.Titulo 
FROM Autor au
INNER JOIN Autor_Libro auli ON au.Codigo=auli.Cod_autor
INNER JOIN Libro li ON auli.Cod_libro=li.Codigo 

--b. Se desea conocer todos los autores que tienen libros que han sido publicados por la
--editorial “Omega”.

select au.Codigo,au.Nombres, au.Apellidos, au.Nacionalidad
FROM Autor au
INNER JOIN Autor_Libro auli ON au.Codigo=auli.Cod_autor
INNER JOIN Libro li ON auli.Cod_libro=li.Codigo
WHERE li.Cod_editorial='ED02'

--c. Mostrar cuántos ejemplares hay por cada libro. Titulo, ejemplar
SELECT li.Titulo,count(*) AS 'EJEMPLARES'
FROM Libro li
INNER JOIN Ejemplar ej ON li.Codigo=ej.Cod_libro
group by ej.Cod_libro,li.Titulo

--d. Mostrar los títulos de los libros donde el estado sea “Prestado”.
SELECT li.Titulo
FROM Libro li
INNER JOIN Ejemplar ej ON li.Codigo=ej.Cod_libro
WHERE ej.Estado='Prestado'
group by ej.Estado, li.Titulo

--e. Se desea mostrar los libros que se han editados entre el 2000 y 2007. Ordenarlos en
--forma ascendente.
SELECT *
FROM Libro li
WHERE Annio_edicion BETWEEN 2000 AND 2007
ORDER BY Titulo ASC

--f. Mostrar cuántos libros que se han prestado y agruparlos por el estante
SELECT ej.Ubicacion,li.Titulo, COUNT(*) AS 'LIBROS POR ESTANTE'
FROM Libro li
INNER JOIN Ejemplar ej ON li.Codigo=ej.Cod_libro
WHERE ej.Estado='Prestado'
group by ej.Ubicacion, li.Titulo


/* ================== Parte #3 ================== */

/* Crear la tabla autores_espana, utilice un insert select, para insertar los autores que sean de españa */

create table autores_espana(
Codigo varchar(4) primary key,
Nombres varchar(50),
Apellidos varchar(50)
)

insert into autores_espana
select Codigo,Nombres,Apellidos
from Autor
where Nacionalidad = 'Española'

/* Crear una vista con el nomber copia_libro va a utilizar las tablas title, item y copy, de la
base de datos LIBRARY y va a generar una consulta que devuelva isbn, copy_no,
on_loan, title, translation y cover, y valores para las filas de la tabla copy cuyo ISBN sea 1
(uno), 500 (quinientos) o 1000 (mil). Ordene los resultados por la columna isbn. Para cada
tabla debe utilizar un alias  */

use library


if object_id('copia_libro') is not null
  drop view copia_libro;
  go

create view copia_libro 
	as select top 100 percent i.isbn as 'ISBN',c.copy_no as 'N° de copia',c.on_loan as 'En préstamo', t.title as 'Título', i.translation as 'Traducción', i.cover as 'Tapa'
	from item i
	inner join copy c on i.isbn = c.isbn
	inner join title t on c.title_no = t.title_no
	where i.isbn in ('1','500','1000')
	order by i.isbn asc
go

/* Mostrando información de la vista */
select * from copia_libro
order by isbn asc

