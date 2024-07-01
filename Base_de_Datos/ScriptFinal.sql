CREATE DATABASE proyectoFinal_BD;
Use proyectoFinal_BD;

CREATE TABLE genero (
    codigo INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(20),
    PRIMARY KEY (codigo)
);

CREATE TABLE nacionalidad (
    codigo INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(20),
    PRIMARY KEY (codigo)
);

CREATE TABLE detenido (
    identificador             INT NOT NULL AUTO_INCREMENT,
    edad                      INT,
    sexo                      VARCHAR(15),
    autoidentificacion_etnica VARCHAR(50),
    estatus_migratorio        VARCHAR(15),
    numero_detenciones        INT,
    estado_civil              VARCHAR(20),
    nivel_instruccion         VARCHAR(50),
    nacionalidad_codigo       INT NOT NULL,
    genero_codigo             INT NOT NULL,
    PRIMARY KEY (identificador)
);

ALTER TABLE detenido
    ADD CONSTRAINT genero_fk FOREIGN KEY (genero_codigo)
        REFERENCES genero (codigo);

ALTER TABLE detenido
    ADD CONSTRAINT nacionalidad_fk FOREIGN KEY (nacionalidad_codigo)
        REFERENCES nacionalidad (codigo);

CREATE TABLE lugar (
    codigo INT NOT NULL AUTO_INCREMENT,
    tipo   VARCHAR(50),
    nombre VARCHAR(50),
    PRIMARY KEY (codigo)
);

CREATE TABLE arma (
    codigo INT NOT NULL AUTO_INCREMENT,
    tipo   VARCHAR(50),
    nombre VARCHAR(50),
    PRIMARY KEY (codigo)
);

CREATE TABLE zona (
    codigo INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(20),
    PRIMARY KEY (codigo)
);

CREATE TABLE subzona (
    codigo      INT NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(50),
    zona_codigo INT NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE subzona
    ADD CONSTRAINT zona_fkv1 FOREIGN KEY (zona_codigo)
        REFERENCES zona (codigo);

CREATE TABLE provincia (
    codigo      INT NOT NULL,
    nombre      VARCHAR(50),
    zona_codigo INT NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE provincia
    ADD CONSTRAINT zona_fkv2 FOREIGN KEY (zona_codigo)
        REFERENCES zona (codigo);

CREATE TABLE canton ( 
    codigo           INT NOT NULL,
    nombre           VARCHAR(50),
    provincia_codigo INT NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE canton
    ADD CONSTRAINT provincia_fkv1 FOREIGN KEY (provincia_codigo)
        REFERENCES provincia (codigo);

CREATE TABLE parroquia (
    codigo        VARCHAR(15) NOT NULL,
    nombre        VARCHAR(100),
    canton_codigo INT NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE parroquia
    ADD CONSTRAINT canton_fk FOREIGN KEY (canton_codigo)
        REFERENCES canton (codigo);

CREATE TABLE distrito (
    codigo           VARCHAR(8) NOT NULL,
    nombre           VARCHAR(50),
    parroquia_codigo VARCHAR(10) NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE distrito
    ADD CONSTRAINT parroquia_fk FOREIGN KEY (parroquia_codigo)
        REFERENCES parroquia (codigo);

CREATE TABLE circuito (
    codigo          VARCHAR(10) NOT NULL,
    nombre          VARCHAR(50),
    distrito_codigo VARCHAR(8) NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE circuito
    ADD CONSTRAINT distrito_fk FOREIGN KEY (distrito_codigo)
        REFERENCES distrito (codigo);

CREATE TABLE subcircuito (
    codigo          VARCHAR(15) NOT NULL,
    nombre          VARCHAR(50),
    circuito_codigo VARCHAR(10) NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE subcircuito
    ADD CONSTRAINT circuito_fk FOREIGN KEY (circuito_codigo)
        REFERENCES circuito (codigo);

CREATE TABLE detencion (
    codigo                      INT NOT NULL,
    tipo                        VARCHAR(20),
    codigo_iccs                 VARCHAR(10),
    presunta_infraccion         VARCHAR(300),
    presunta_subinfraccion      VARCHAR(300),
    fecha_detencion_aprehension DATE,
    hora_detencion_aprehension  TIMESTAMP,
    movilizacion                VARCHAR(50),
    presunta_flagrancia         VARCHAR(20),
    condicion                   VARCHAR(200),
    presunta_modalidad          VARCHAR(1000),
    detenido_identificador      INT NOT NULL,
    lugar_codigo                INT NOT NULL,
    arma_codigo                 INT NOT NULL,
    zona_codigo                 INT NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE detencion
    ADD CONSTRAINT arma_fk FOREIGN KEY (arma_codigo)
        REFERENCES arma (codigo);
        
ALTER TABLE detencion
    ADD CONSTRAINT detenido_fk FOREIGN KEY (detenido_identificador)
        REFERENCES detenido (identificador);

ALTER TABLE detencion
    ADD CONSTRAINT zona_fk FOREIGN KEY (zona_codigo)
        REFERENCES zona (codigo);
        
        
ALTER TABLE detencion
    ADD CONSTRAINT lugar_fk FOREIGN KEY (lugar_codigo)
        REFERENCES lugar (codigo);

CREATE TABLE estadisticas (
    codigo           INT NOT NULL AUTO_INCREMENT,
    anio             INT,
    indice_mortalidad    FLOAT,
    indice_pobresa       FLOAT,
    indice_criminalidad  FLOAT,
    migrantes_provincia  INT,
    provincia_codigo INT NOT NULL,
    PRIMARY KEY (codigo)
);

ALTER TABLE estadisticas
    ADD CONSTRAINT provincia_fk FOREIGN KEY (provincia_codigo)
        REFERENCES provincia (codigo);
        
-- INSERCION

-- GENERO

INSERT INTO genero (nombre)
SELECT DISTINCT genero FROM datosbaselimpios;

-- NACIONALIDAD

INSERT INTO nacionalidad (nombre)
SELECT DISTINCT nacionalidad FROM datosbaselimpios;

-- DETENIDO

INSERT INTO detenido (
    edad,
    sexo,
    autoidentificacion_etnica,
    estatus_migratorio,
    numero_detenciones,
    estado_civil,
    nivel_instruccion,
    nacionalidad_codigo,
    genero_codigo
)
SELECT
    db.edad,
    db.sexo,
    db.autoidentificacion_etnica,
    db.estatus_migratorio,
    db.numero_detenciones,
    db.estado_civil,
    db.nivel_instruccion,
    n.codigo AS nacionalidad_codigo,
    g.codigo AS genero_codigo
FROM
    datosbaselimpios db
JOIN
    nacionalidad n ON db.nacionalidad = n.nombre
JOIN
    genero g ON db.genero = g.nombre;

-- LUGAR(en teoria esta bien, pues en la tabla principal constan los mismos datos)

INSERT INTO lugar (tipo, nombre)
SELECT DISTINCT tipo_lugar, lugar FROM datosbaselimpios;
select * from lugar;

-- ARMA
INSERT INTO arma (tipo, nombre)
SELECT DISTINCT tipo_arma, arma
FROM datosbaselimpios;

-- ZONA
INSERT INTO zona (NOMBRE)
SELECT DISTINCT zona
from datosbaselimpios;

-- SUBZONA
INSERT INTO subzona (nombre, zona_codigo)
VALUES
 ('AZUAY', 6),
 ('BOLIVAR', 5),
 ('CAÑAR', 6),
 ('CARCHI', 1),
 ('CHIMBORAZO', 3),
 ('COTOPAXI', 3),
 ('DMG', 8),
 ('DMQ', 9),
 ('EL ORO', 7),
 ('ESMERALDAS', 1),
 ('GALAPAGOS', 5),
 ('GUAYAS', 5),
 ('IMBABURA', 1),
 ('LOJA', 7),
 ('LOS RIOS', 5),
 ('MANABI', 4),
 ('MAR TERRITORIAL', 10),
 ('MORONA SANTIAGO', 6),
 ('NAPO', 2),
 ('ORELLANA', 2),
 ('PASTAZA', 3),
 ('PICHINCHA', 2),
 ('SANTA ELENA', 5),
 ('SANTO DOMINGO DE LOS TSACHILAS', 4),
 ('SUCUMBIOS', 1),
 ('TUNGURAHUA', 3),
 ('ZAMORA CHINCHIPE', 7);

-- PROVINCIA
INSERT INTO provincia (codigo, nombre, zona_codigo)
VALUES
 (1,'AZUAY', 6),
 (2,'BOLIVAR', 5),
 (3,'CAÑAR', 6),
 (4,'CARCHI', 1),
 (6,'CHIMBORAZO', 3),
 (5,'COTOPAXI', 3),
 (7,'EL ORO', 7),
 (8,'ESMERALDAS', 1),
 (20,'GALAPAGOS', 5),
 (9,'GUAYAS', 5),
 (10,'IMBABURA', 1),
 (11,'LOJA', 7),
 (12,'LOS RIOS', 5),
 (13,'MANABI', 4),
 (88,'MAR TERRITORIAL', 10),
 (14,'MORONA SANTIAGO', 6),
 (15,'NAPO', 2),
 (22,'ORELLANA', 2),
 (16,'PASTAZA', 3),
 (17,'PICHINCHA', 2),
 (24,'SANTA ELENA', 5),
 (23,'SANTO DOMINGO DE LOS TSACHILAS', 4),
 (21,'SUCUMBIOS', 1),
 (18,'TUNGURAHUA', 3),
 (19,'ZAMORA CHINCHIPE', 7);

-- CANTON
INSERT canton(codigo, nombre, provincia_codigo)
SELECT DISTINCT d.codigo_canton, d.canton, p.codigo
FROM datosbaselimpios d
 INNER JOIN provincia p ON d.provincia = p.nombre
WHERE d.codigo_canton <> 'SIN DATO'
 AND NOT (d.canton = 'LA CONCORDIA' AND d.codigo_canton = '808' AND p.codigo = '8');

-- PARROQUIA
INSERT IGNORE INTO parroquia (CODIGO, NOMBRE, CANTON_CODIGO)
SELECT distinct d.codigo_parroquia, d.parroquia, p.codigo
FROM datosbaselimpios d
 INNER JOIN canton p ON p.nombre = d.canton
WHERE d.codigo_parroquia <> 'SIN DATO';

-- DISTRITO
INSERT IGNORE INTO distrito(codigo, nombre, parroquia_codigo)
SELECT distinct d.codigo_distrito, d.nombre_distrito, p.codigo
FROM datosbaselimpios d
 INNER JOIN parroquia p ON d.codigo_parroquia = p.codigo;

-- CIRCUITO
INSERT IGNORE INTO circuito(codigo, nombre, distrito_codigo)
SELECT distinct c.codigo_circuito, c.nombre_circuito, d.codigo
FROM datosbaselimpios c
 INNER JOIN distrito d ON c.codigo_distrito = d.codigo
WHERE c.codigo_circuito <> 'SIN DATO';

-- SUBCIRCUITO
INSERT IGNORE INTO subcircuito(codigo, nombre, circuito_codigo)
SELECT distinct d.codigo_subcircuito, d.nombre_subcircuito, c.codigo
FROM datosbaselimpios d
 INNER JOIN circuito c ON d.codigo_circuito = c.codigo
WHERE d.codigo_subcircuito <> 'SIN DATO';

-- DETENCION
INSERT IGNORE INTO detencion(codigo, tipo, codigo_iccs, presunta_infraccion,
presunta_subinfraccion,
 fecha_detencion_aprehension, hora_detencion_aprehension, movilizacion,
 presunta_flagrancia, condicion, presunta_modalidad, detenido_identificador,
 lugar_codigo, arma_codigo, zona_codigo)
SELECT d.codigo_detencion,d.tipo, d.codigo_iccs,d.presunta_infraccion,
d.presunta_subinfraccion, d.fecha_detencion, d.hora_detencion,
 d.movilizacion, d.presunta_flagrancia, d.condicion, d.presunta_modalidad, de.identificador,
 l.codigo, a.codigo, z.codigo
FROM datosbaselimpios d
 LEFT JOIN (SELECT identificador FROM detenido GROUP BY identificador) de ON
d.codigo_detencion = de.identificador
 LEFT JOIN (SELECT nombre, MIN(codigo) as codigo FROM lugar GROUP BY nombre) l
ON l.nombre = d.lugar
 LEFT JOIN (SELECT nombre, MIN(codigo) as codigo FROM arma GROUP BY nombre) a
ON a.nombre = d.arma
 LEFT JOIN (SELECT nombre, MIN(codigo) as codigo FROM zona GROUP BY nombre) z
ON z.nombre = d.zona;

-- Estadisticas

INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 12.8, 1);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 13.0, 1);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 12.5, 1);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 29.0, 10);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 29.4, 10);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 28.8, 10);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 25.5, 11);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 26.0, 11);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 25.0, 11);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 29.5, 12);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 30.0, 12);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 29.0, 12);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 30.5, 13);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 31.0, 13);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 30.0, 13);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 65.3, 14);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 65.8, 14);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 65.0, 14);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 52.5, 15);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 53.0, 15);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 52.0, 15);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 39.5, 16);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 40.0, 16);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 39.0, 16);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 64.5, 17);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 65.0, 17);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 64.0, 17);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 10.8, 18);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 11.0, 18);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 10.5, 18);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 28.5, 19);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 29.0, 19);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 28.0, 19);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 43.5, 2);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 44.0, 2);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 43.0, 2);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 24.5, 20);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 25.0, 20);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 24.0, 20);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 44.5, 21);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 45.0, 21);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 44.0, 21);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 17.8, 22);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 18.0, 22);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 17.5, 22);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 35.5, 23);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 36.0, 23);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 35.0, 23);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 9.5, 24);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 10.0, 24);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 9.3, 24);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 36.5, 3);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 37.0, 3);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 36.0, 3);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 29.5, 4);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 30.0, 4);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 29.0, 4);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 44.5, 5);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 45.0, 5);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 44.0, 5);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 40.5, 6);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 41.0, 6);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 40.0, 6);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 15.0, 7);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 15.3, 7);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 14.8, 7);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 31.5, 8);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 32.0, 8);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 31.0, 8);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2023, 20.5, 9);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2022, 21.0, 9);
INSERT INTO estadisticas (anio, indice_pobresa, provincia_codigo) VALUES (2024, 20.3, 9);

INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.38, 1);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.35, 1);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.41, 1);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.34, 10);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.41, 10);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.36, 10);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.25, 11);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.32, 11);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.43, 11);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.28, 12);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.33, 12);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.29, 12);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.31, 13);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.27, 13);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.33, 13);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.19, 14);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.29, 14);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.2, 14);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.22, 15);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.18, 15);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.23, 15);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.23, 16);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.2, 16);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.24, 16);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.42, 17);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.19, 17);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.44, 17);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.35, 18);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.22, 18);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.37, 18);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.22, 19);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.4, 19);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.23, 19);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.23, 2);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.21, 2);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.24, 2);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.17, 20);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.26, 20);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.18, 20);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.24, 21);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.28, 21);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.25, 21);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.2, 22);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.23, 22);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.21, 22);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.3, 23);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.34, 23);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.31, 23);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.27, 24);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.2, 24);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.28, 24);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.42, 3);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.4, 3);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.45, 3);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.34, 4);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.33, 4);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.35, 4);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.26, 5);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.31, 5);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.27, 5);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.33, 6);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.25, 6);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.35, 6);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.29, 7);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.28, 7);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.3, 7);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.31, 8);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.3, 8);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.32, 8);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2023, 0.43, 9);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2022, 0.15, 9);
INSERT INTO estadisticas (anio, migrantes_provincia, provincia_codigo) VALUES (2024, 0.45, 9);

INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 44.0, 2);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 18.0, 18);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 29.4, 10);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 45.0, 6);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 32.0, 8);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 65.0, 16);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 11.0, 17);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 15.3, 7);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 30.0, 12);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 40.0, 22);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 31.0, 13);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 30.0, 4);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 41.0, 5);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 53.0, 15);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 37.0, 3);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 26.0, 11);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 65.8, 14);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 13.0, 1);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 36.0, 19);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 45.0, 21);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 10.0, 20);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 25.0, 23);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 21.0, 9);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2022, 29.0, 24);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 12.8, 1);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 12.5, 1);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 29.0, 10);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 28.8, 10);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 25.5, 11);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 25.0, 11);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 29.5, 12);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 29.0, 12);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 30.5, 13);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 30.0, 13);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 65.3, 14);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 65.0, 14);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 52.5, 15);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 52.0, 15);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 64.5, 16);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 64.0, 16);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 10.8, 17);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 10.5, 17);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 17.8, 18);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 17.5, 18);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 35.5, 19);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 35.0, 19);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 43.5, 2);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 43.0, 2);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 9.5, 20);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 9.3, 20);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 44.5, 21);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 44.0, 21);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 39.5, 22);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 39.0, 22);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 24.5, 23);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 24.0, 23);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 28.5, 24);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 28.0, 24);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 36.5, 3);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 36.0, 3);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 29.5, 4);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 29.0, 4);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 40.5, 5);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 40.0, 5);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 44.5, 6);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 44.0, 6);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 15.0, 7);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 14.8, 7);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 31.5, 8);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 31.0, 8);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2023, 20.5, 9);
INSERT INTO estadisticas (anio, indice_mortalidad, provincia_codigo) VALUES (2024, 20.3, 9);

INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.045, 9);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.014, 11);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.02, 10);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.035, 24);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.06, 13);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.05, 21);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.05, 7);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.04, 17);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.045, 23);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.014, 5);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.018, 18);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.028, 15);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.05, 12);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.04, 3);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.02, 4);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.016, 6);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.032, 22);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.1, 8);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.012, 3);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.024, 16);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.016, 1);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.004, 20);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.02, 19);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.03, 14);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2023, 0.04, 88);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.006, 3);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.009, 18);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.01, 10);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.008, 6);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.06333, 8);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.012, 16);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.02, 17);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.03044, 7);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.03233, 12);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.016, 22);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.03651, 13);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.01, 4);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.007, 5);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.014, 15);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.02679, 3);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.007, 11);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.015, 14);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.008, 1);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.01, 19);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.02868, 21);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.002, 20);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.02615, 23);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.02689, 9);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2022, 0.01768, 24);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.02, 1);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.04, 24);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.025, 19);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.045, 3);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.045, 17);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.018, 11);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.06, 7);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.05, 9);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.065, 13);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.025, 10);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.055, 12);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.02, 6);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.11, 8);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.035, 14);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.015, 3);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.05, 23);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.022, 18);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.03, 15);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.035, 22);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.025, 4);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.018, 5);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.055, 21);
INSERT INTO estadisticas (anio, indice_criminalidad, provincia_codigo) VALUES (2024, 0.028, 16);
