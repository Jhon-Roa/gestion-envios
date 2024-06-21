# Base de datos sobre gestion de envios

Como una firma de consultoría que se especializa en el desarrollo de bases de datos, ha obtenido
una licitación para el desarrollo de un modelo de datos y un sistema de gestión de distribución de
paquetes para un proveedor de logística cuya operación es a nivel nacional e internacional con
sucursales y operaciones similares a las de Amazon. Ofrece servicios de distribución de paquetes
a nivel nacional e internacional con sucursales en diferentes ciudades y países. El sistema se
ocupará de la gestión de paquetes, el seguimiento de envíos, la información de los clientes, el
control de sucursales, vehículos, chóferes y asistentes de distribución, así como.

## Diagrama de la base de datos:

![](/home/jhonroa/Descargas/gestion_envios.png)

## Solución de casos de uso:

> [!IMPORTANT]
>
> Los siguientes casos de uso están conectados, por ende para que funcionen deben realizarse en order



- ### Caso de uso 1: Registrar un nuevo país

  ```sql
  INSERT INTO paises(nombre)
  VALUES ('Nepal');
  ```

- ### Caso de uso 2: Registrar una nueva ciudad

  ```sql
  INSERT INTO ciudades(nombre, pais_id)
  VALUES ('Katmandu', 16);
  ```

- ### Caso de uso 3: Registrar una nueva sucursal

  ```sql
  INSERT INTO sucursales(nombre, direccion, ciudad_id)
  VALUES ('Sucursal central de Katmandu', '132 Main Av', 17);
  ```

- ### Caso de uso 4: Registrar un nuevo cliente

  ```sql
  INSERT INTO clientes (nombre, apellido, email) 
  VALUES ('Pablo', 'Hernandez', 'pablo.hernandez@example.com');
  ```

- ### Caso de uso 5: Registrar un nuevo teléfono para un cliente

  ```sql
  INSERT INTO telefonos_clientes (numero, cliente_id, id_tipo_telefono) 
  VALUES ('312-5184702', 11, 1);
  ```

- ### Caso de uso 6: Registrar un nuevo paquete

  ```sql
  INSERT INTO paquetes (numero_seguimiento, peso, dimensiones, contenido, valor_declarado, id_tipo_servicio) 
  VALUES ('PKG1323233', 3.25, '20x30x10 cm', 'Cds de dudosa procedencia', 50.00, 1);
  ```

- ### Caso de uso 7: Registrar un nuevo envió

  ```sql
  INSERT INTO envios (cliente_id, id_direccion_destinatario, paquete_id, fecha_envio, id_ruta, id_sucursal_salida, id_sucursal_destino, id_estado_envio) 
  VALUES (11, 7, 11, '2024-02-20 09:00:00', 5, 1, 2, 1);
  ```

- ### Caso de uso 8: Registrar un nuevo vehiculo

  ```sql
  INSERT INTO vehiculos (placa, capacidad_carga, modelo_id, sucursal_id) 
  VALUES ('QUD80B', 5000.00, 1, 1);
  ```

- ### Caso de uso 9: Registrar un nuevo conductor

  ```sql
  INSERT INTO conductores (documento, id_tipo_documento, nombre, apellido) 
  VALUES ('6323228', 1, 'Carlos', 'Mendez');
  ```

- ### Caso de uso 10: Registrar un nuevo numero para un conductor

  ```sql
  INSERT INTO telefonos_conductores (numero, conductor_documento, id_tipo_telefono) 
  VALUES ('313-3232233', '6323228', 1);
  ```

- ### Caso de Uso 11: Asignar un Conductor a una Ruta y un Vehículo

  ```sql
  INSERT INTO conductores_rutas (documento_conductor, id_ruta, placa_vehiculo) 
  VALUES ('6323228', 6, 'QUD80B');
  ```

- ### Caso de Uso 12: Registrar un nuevo auxiliar

  ```sql
  INSERT INTO auxiliares (documento, id_tipo_documento, nombre, apellido) 
  VALUES ('110234222', 1, 'Ronal', 'García');
  ```

- ### Caso de Uso 13: Asignar un auxiliar a una ruta

  ```sql
  INSERT INTO ruta_auxiliar (id_ruta, documento_auxiliar) 
  VALUES (6, '110234222');
  ```

- ### Caso de Uso 14: Registrar un Evento de Seguimiento para un Paquete

  ```sql
  INSERT INTO seguimiento (id_paquete, ubicacion, fecha_hora, id_estado) 
  VALUES (11, 'Nueva York', '2024-02-10 20:00:00', 2);
  ```

- ### Caso de Uso 15: Generar un Reporte de Envíos por Cliente

  ```sql
  SELECT c.nombre AS nombre_cliente, e.id AS id_envio
  FROM envios AS e
  JOIN clientes AS c ON c.id = e.cliente_id
  WHERE c.id = 11;
  ```

- ### Caso de Uso 16: Actualizar el estado de un paquete 

  > [!NOTE]
  >
  > En el ddl se creo un trigger con el objetivo de que lo que se modifique sea el seguimiento añadiendo una row a la tabla, y el estado de el paquete se modifique en envió según este.

  

  ```sql
  INSERT INTO seguimiento (id_paquete, ubicacion, fecha_hora, id_estado) 
  VALUES (11, 'Los angeles', '2024-03-10 12:00:00', 3);
  ```

- ### Caso de Uso 17: Rastrear la ubicación actual de un paquete

  ```sql
  SELECT p.contenido AS contenido, s.ubicacion AS ubicacion, s.fecha_hora AS fecha
  FROM seguimiento AS s
  JOIN (
      SELECT id_paquete, MAX(fecha_hora) AS max_fecha_hora
      FROM seguimiento
      GROUP BY id_paquete
  ) AS max_fecha ON s.id_paquete = max_fecha.id_paquete AND s.fecha_hora = max_fecha.max_fecha_hora
  JOIN paquetes AS p ON p.id = max_fecha.id_paquete
  WHERE p.numero_seguimiento = 'PKG1323233'; 
  ```

## Casos multitabla

- ### Caso de Uso 1: Obtener Información Completa de Envíos

  ```sql
  SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente,
      p.contenido AS contenido_paquete,
      r.descripcion AS ruta,
      CONCAT(co.nombre, ' ', co.apellido) AS conductor,
      ss.nombre AS sucursal_salida,
      sd.nombre AS sucursal_destino
  FROM envios AS e
  JOIN clientes AS c ON c.id = e.cliente_id
  JOIN paquetes AS p ON p.id = e.paquete_id
  JOIN rutas AS r ON r.id = e.id_ruta
  JOIN conductores_rutas AS coru ON r.id = coru.id_ruta
  JOIN conductores AS co ON co.documento = coru.documento_conductor
  JOIN sucursales AS ss ON ss.id = e.id_sucursal_salida 
  JOIN sucursales AS sd ON sd.id = e.id_sucursal_destino
  ORDER BY e.id;
  ```

- ### Caso de Uso 2: Obtener Historial de Envíos de un Cliente

  ```sql
  SELECT 
  FROM clientes AS c
  JOIN envios AS e ON c.id = e.cliente_id
  JOIN paquetes AS o ON p.id = e.paquete_id
  JOIN seguimiento AS s ON p.id = s.id_paquete
  ```

  
