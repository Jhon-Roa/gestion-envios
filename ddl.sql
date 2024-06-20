--  elimina la base de datos si ya existe

DROP DATABASE IF EXISTS gestion_de_envios;

-- crea la base de datos

CREATE DATABASE gestion_de_envios;

USE gestion_de_envios;

-- creacion de tablas

-- tablas principales (no necesitan llaves foraneas)

CREATE TABLE paises (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_id_paises PRIMARY KEY (id),
    CONSTRAINT uk_nombre_paises UNIQUE (nombre)
);

-- tabla de estado_envio creada para envios

CREATE TABLE estado_envio (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(20),
    CONSTRAINT pk_id_estado_envio PRIMARY KEY (id),
    CONSTRAINT uk_nombre_estado_envio UNIQUE (nombre)
);

-- tabla tipo_servicio creada para paquetes

CREATE TABLE tipo_servicio (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(20),
    CONSTRAINT pk_id_tipo_servicio PRIMARY KEY (id),
    CONSTRAINT uk_nombre_tipo_servicio UNIQUE (nombre)
);

--  se creo el tipo documento

CREATE TABLE tipo_documentos (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(50),
    CONSTRAINT pk_id_tipo_documentos PRIMARY KEY (id)
);

-- se dividio el nombre de el cliente, conductor y auxiliar en nombre y apellido

CREATE TABLE clientes (
    id INT AUTO_INCREMENT,
    nombre  VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(100),
    CONSTRAINT pk_id_clientes PRIMARY KEY (id),
    CONSTRAINT  uk_email_clientes UNIQUE (email)
);

-- se crea una tabla para guardar la informacion de el destinatario

CREATE TABLE destinatarios (
    id INT AUTO_INCREMENT,
    nombre  VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(20),
    CONSTRAINT pk_id_destinatarios PRIMARY KEY (id)
);


--  se creo la tabla marcas y modelos, de los vehiculos para tener un mejor orden de estos

CREATE TABLE marcas (
    id INT(5) AUTO_INCREMENT,
    nombre VARCHAR(30),
    CONSTRAINT pk_id_marcas PRIMARY KEY (id)
);


-- tablas... No principales

CREATE TABLE ciudades (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    pais_id INT(3),
    CONSTRAINT pk_id_ciudades PRIMARY KEY (id),
    CONSTRAINT fk_pais_id_ciudades FOREIGN KEY (pais_id)
        REFERENCES paises(id)
);

CREATE TABLE sucursales (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    ciudad_id INT(11),
    CONSTRAINT pk_id_sucursales PRIMARY KEY (id),
    CONSTRAINT fk_ciudad_id_sucursales FOREIGN KEY (ciudad_id)
        REFERENCES ciudades(id)
);

CREATE TABLE rutas (
    id INT AUTO_INCREMENT,
    descripcion VARCHAR(200),
    CONSTRAINT pk_id_rutas PRIMARY KEY (id)
);

CREATE TABLE sucursal_ruta (
    id_sucursal INT(11),
    id_ruta INT(11),
    CONSTRAINT pk_sucursal_ruta PRIMARY KEY (id_sucursal, id_ruta),
    CONSTRAINT fk_id_sucursal_sucursal_ruta FOREIGN key (id_sucursal)
        REFERENCES sucursales(id),
    CONSTRAINT fk_id_ruta_sucursal_ruta FOREIGN key (id_ruta)
        REFERENCES rutas(id)
);

CREATE TABLE conductores (
    documento VARCHAR(30),
    id_tipo_documento INT(5),
    nombre  VARCHAR(50),
    apellido VARCHAR(50),
    CONSTRAINT pk_documento_conductores PRIMARY KEY (documento),
    CONSTRAINT fk_id_tipo_documento_conductores FOREIGN KEY (id_tipo_documento)
        REFERENCES tipo_documentos(id)
);

CREATE TABLE auxiliares (
    documento VARCHAR(30),
    id_tipo_documento INT(5),
    nombre  VARCHAR(50),
    apellido VARCHAR(50),
    CONSTRAINT pk_documento_auxiliares PRIMARY KEY (documento),
    CONSTRAINT fk_id_tipo_documento_auxiliares FOREIGN KEY (id_tipo_documento)
        REFERENCES tipo_documentos(id)
);

CREATE TABLE ruta_auxiliar (
    id_ruta INT(11),
    documento_auxiliar VARCHAR(30),
    CONSTRAINT pk_ruta_auxiliar PRIMARY KEY (id_ruta, documento_auxiliar),
    CONSTRAINT fk_id_ruta_ruta_auxiliar FOREIGN KEY (id_ruta)
        REFERENCES rutas(id),
    CONSTRAINT fk_documento_auxiliar_ruta_auxiliar FOREIGN KEY (documento_auxiliar)
        REFERENCES auxiliares(documento)
);

CREATE TABLE telefonos_clientes (
    id INT AUTO_INCREMENT,
    numero VARCHAR(20),
    cliente_id INT(11),
    CONSTRAINT pk_id_telefonos_clientes PRIMARY KEY (id),
    CONSTRAINT fk_cliente_id_telefonos_clientes FOREIGN KEY (cliente_id)
        REFERENCES clientes(id),
    CONSTRAINT uk_numero_telefonos_clientes UNIQUE (numero)
);

CREATE TABLE direcciones (
    id INT AUTO_INCREMENT,
    direccion VARCHAR(200),
    CONSTRAINT pk_id_direcciones PRIMARY KEY (id)
);

CREATE TABLE direccion_destinatario (
    id_direccion INT(11),
    id_destinatario INT(11),
    CONSTRAINT pk_direccion_clientes PRIMARY KEY (id_direccion, id_destinatario),
    CONSTRAINT fk_id_direccion_direccion_destinatario FOREIGN KEY (id_direccion)
        REFERENCES direcciones(id),
    CONSTRAINT fk_id_destinatario_direccion_destinatarios FOREIGN KEY (id_destinatario)
        REFERENCES destinatarios(id)
);

CREATE TABLE telefonos_conductores (
    id INT AUTO_INCREMENT,
    numero VARCHAR(20),
    conductor_documento VARCHAR(30),
    CONSTRAINT pk_id_telefonos_conductores PRIMARY KEY (id),
    CONSTRAINT fk_conductor_documento_telefonos_conductores FOREIGN KEY (conductor_documento)
        REFERENCES conductores(documento),
    CONSTRAINT uk_numero_telefonos_clientes UNIQUE (numero)
);

CREATE TABLE telefonos_auxiliares (
    id INT AUTO_INCREMENT,
    numero VARCHAR(20),
    auxiliar_documento VARCHAR(30),
    CONSTRAINT pk_id_telefonos_auxiliares PRIMARY KEY (id),
    CONSTRAINT fk_auxiliar_documento_telefonos_auxiliares FOREIGN KEY (auxiliar_documento)
        REFERENCES auxiliares(documento),
    CONSTRAINT uk_numero_telefonos_clientes UNIQUE (numero)
);

CREATE TABLE paquetes (
    id INT AUTO_INCREMENT,
    numero_seguimiento VARCHAR(50),
    peso DECIMAL(10, 2),
    dimensiones VARCHAR(50),
    contenido TEXT,
    valor_declarado DECIMAL(10, 2),
    id_tipo_servicio INT(3),
    CONSTRAINT pk_id_paquetes PRIMARY KEY (id),
    CONSTRAINT fk_id_tipo_servicio_paquetes FOREIGN KEY (id_tipo_servicio)
        REFERENCES tipo_servicio(id)
);

--  se añadio el estado en envios, no en seguimiento

CREATE TABLE envios (
    id INT AUTO_INCREMENT,
    cliente_id INT(11),
    destinatario_id INT(11),
    paquete_id INT(11),
    fecha_envio TIMESTAMP,
    id_direccion INT(11),
    ruta_id INT(11),
    id_sucursal_salida INT(11),
    id_sucursal_destino INT(11),
    id_estado_envio INT(3),
    CONSTRAINT pk_id_envios PRIMARY KEY (id),
    CONSTRAINT fk_cliente_id_envios FOREIGN KEY (cliente_id)
        REFERENCES clientes(id),
    CONSTRAINT fk_destinatario_id FOREIGN KEY (destinatario_id)
        REFERENCES destinatarios(id),
    CONSTRAINT fk_paquete_id_envios FOREIGN KEY (paquete_id)
        REFERENCES paquetes(id),
    CONSTRAINT fk_id_direccion_envios FOREIGN KEY (id_direccion)
        REFERENCES direcciones(id),
    CONSTRAINT fk_ruta_id_envios FOREIGN KEY (ruta_id)
        REFERENCES rutas(id),
    CONSTRAINT fk_id_sucursal_salida_envios FOREIGN KEY (id_sucursal_salida)
        REFERENCES sucursales(id),
    CONSTRAINT fk_id_sucursal_destino_envios FOREIGN KEY (id_sucursal_destino)
        REFERENCES sucursales(id),
    CONSTRAINT fk_id_estado_envio_envios FOREIGN KEY (id_estado_envio)
        REFERENCES estado_envio(id)
);

CREATE TABLE seguimiento (
    id INT AUTO_INCREMENT,
    id_paquete INT(11),
    ubicacion VARCHAR(200),
    fecha_hora TIMESTAMP,
    id_estado INT(3),
    CONSTRAINT pk_id_seguimiento PRIMARY KEY (id),
    CONSTRAINT fk_id_paquete_seguimiento FOREIGN KEY (id_estado)
        REFERENCES  estado_envio(id)
);

CREATE TABLE modelos (
    id INT(5) AUTO_INCREMENT,
    nombre VARCHAR(30),
    id_marca INT(5),
    CONSTRAINT pk_id_modelos PRIMARY KEY (id),
    CONSTRAINT fk_id_marca_modelos FOREIGN KEY (id_marca)
        REFERENCES marcas(id)
);

--  se elimino id de vehiculos y se hizo la primary key la placa del vehiculo

CREATE TABLE vehiculos (
    placa VARCHAR(50),
    capacidad_carga DECIMAL(10,2),
    modelo_id INT(5),
    sucursal_id INT(11),
    CONSTRAINT pk_placa_vehiculos PRIMARY KEY (placa),
    CONSTRAINT fk_modelo_id_vehiculos FOREIGN KEY (modelo_id)
        REFERENCES modelos(id),
    CONSTRAINT fk_sucursal_id_vehiculos FOREIGN KEY (sucursal_id)
        REFERENCES sucursales(id)
);

CREATE TABLE conductores_rutas (
    documento_conductor VARCHAR(30),
    id_ruta INT(11),
    placa_vehiculo VARCHAR(50),
    CONSTRAINT pk_conductores_rutas PRIMARY KEY (documento_conductor, id_ruta),
    CONSTRAINT fk_documento_conductor FOREIGN KEY (documento_conductor)
        REFERENCES conductores(documento),
    CONSTRAINT fk_id_ruta FOREIGN KEY (id_ruta)
        REFERENCES rutas(id),
    CONSTRAINT fk_placa_vehiculo FOREIGN KEY (placa_vehiculo)
        REFERENCES vehiculos(placa) 
);