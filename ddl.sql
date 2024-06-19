-- elimina la base de datos si ya existe

DROP DATABASE IF EXISTS gestion_de_envios;

--crea la base de datos

CREATE DATABASE gestion_de_envios;

--creacion de tablas

--tablas principales (no necesitan llaves foraneas)

CREATE TABLE paises (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_id_paises PRIMARY KEY (id),
    CONSTRAINT uk_nombre_paises UNIQUE (nombre)
);

--tabla de estado_envio creada para envios

CREATE TABLE estado_envio (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(20),
    CONSTRAINT pk_id_estado_envio PRIMARY KEY (id),
    CONSTRAINT uk_nombre_estado_envio UNIQUE (nombre)
);

--tabla de estado_paquete creada para paquetes

CREATE TABLE estado_paquete (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(20),
    CONSTRAINT pk_id_estado_paquete PRIMARY KEY (id),
    CONSTRAINT uk_nombre_estado_paquete UNIQUE (nombre)
);

--tabla tipo_servicio creada para paquetes

CREATE TABLE tipo_servicio (
    id INT(3) AUTO_INCREMENT,
    nombre VARCHAR(20),
    CONSTRAINT pk_id_tipo_servicio PRIMARY KEY (id),
    CONSTRAINT uk_nombre_tipo_servicio UNIQUE (nombre)
);

--se dividio el nombre de el cliente, conductor y auxiliar en nombre y apellido

CREATE TABLE clientes (
    id INT AUTO_INCREMENT,
    nombre  VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(100),
    CONSTRAINT pk_id_clientes PRIMARY KEY (id),
    CONSTRAINT  uk_email_clientes UNIQUE (email)
);

CREATE TABLE conductores (
    id INT(5) AUTO_INCREMENT,
    nombre  VARCHAR(50),
    apellido VARCHAR(50),
    CONSTRAINT pk_id_conductores PRIMARY KEY (id)
);

CREATE TABLE auxiliares (
    id INT(5) AUTO_INCREMENT,
    nombre  VARCHAR(50),
    apellido VARCHAR(50),
    CONSTRAINT pk_id_auxiliares PRIMARY KEY (id)
);


--tablas... No principales

CREATE TABLE ciudades (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    pais_id INT(3),
    CONSTRAINT pk_id_ciudades PRIMARY KEY (id),
    CONSTRAINT fk_pais_id_ciudades FOREIGN KEY pais_id
        REFERENCES paises(id)
)

CREATE TABLE sucursales (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    ciudad_id INT(11),
    CONSTRAINT pk_id_sucursales PRIMARY KEY (id),
    CONSTRAINT fk_ciudad_id_sucursales FOREIGN KEY ciudad_id
        REFERENCES ciudades(id)
)

CREATE TABLE rutas (
    id INT AUTO_INCREMENT,
    descripcion VARCHAR(200),
    sucursal_id INT(11),
    CONSTRAINT pk_id_rutas PRIMARY KEY (id),
    CONSTRAINT fk_sucursal_id_rutas FOREIGN KEY sucursal_id
        REFERENCES sucursales(id)
)

CREATE TABLE paquetes (
    id INT AUTO_INCREMENT,
    numero_seguimiento VARCHAR(50),
    peso DECIMAL(10, 2),
    dimensiones VARCHAR(50),
    contenido TEXT,
    valor_declarado DECIMAL(10, 2),
    id_tipo_servicio INT(3),
    id_estado_paquete INT(3),
    CONSTRAINT pk_id_paquetes PRIMARY KEY (id),
    CONSTRAINT fk_id_tipo_servicio_paquetes FOREIGN KEY id_tipo_servicio
        REFERENCES tipo_servicio(id),
    CONSTRAINT fk_id_estado_paquete_paquetes FOREIGN KEY id_estado_paquete
        REFERENCES estado_paquete(id)
);

CREATE TABLE telefonos_clientes (
    id INT AUTO_INCREMENT,
    numero VARCHAR(20),
    cliente_id INT(11),
    CONSTRAINT pk_id_telefonos_clientes PRIMARY KEY (id),
    CONSTRAINT fk_cliente_id_telefonos_clientes FOREIGN KEY cliente_id
        REFERENCES clientes(id),
    CONSTRAINT uk_numero_telefonos_clientes UNIQUE (numero)
);

CREATE TABLE direcciones_clientes (
    id INT AUTO_INCREMENT,
    direccion VARCHAR(200),
    cliente_id INT(11),
    CONSTRAINT pk_id_direcciones_clientes PRIMARY KEY (id),
    CONSTRAINT fk_cliente_id_direcciones_clientes FOREIGN KEY cliente_id
        REFERENCES clientes(id),
    CONSTRAINT uk_numero_direcciones_clientes UNIQUE (direccion)
);

CREATE TABLE telefonos_conductores (
    id INT AUTO_INCREMENT,
    numero VARCHAR(20),
    conductor_id INT(11),
    CONSTRAINT pk_id_telefonos_conductores PRIMARY KEY (id),
    CONSTRAINT fk_conductor_id_telefonos_conductores FOREIGN KEY conductor_id
        REFERENCES conductores(id),
    CONSTRAINT uk_numero_telefonos_clientes UNIQUE (numero)
);

CREATE TABLE telefonos_auxiliares (
    id INT AUTO_INCREMENT,
    numero VARCHAR(20),
    auxiliar_id INT(11),
    CONSTRAINT pk_id_telefonos_auxiliares PRIMARY KEY (id),
    CONSTRAINT fk_auxiliar_id_telefonos_auxiliares FOREIGN KEY auxiliar_id
        REFERENCES auxiliares(id),
    CONSTRAINT uk_numero_telefonos_clientes UNIQUE (numero)
);

CREATE TABLE envios (
    id INT AUTO_INCREMENT,
    cliente_id INT(11),
    paquete_id INT(11),
    fecha_envio TIMESTAMP,
    destino VARCHAR(200)
)
