-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS MonitoreoAgricola;
USE MonitoreoAgricola;

-- Tabla Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    estado_verificacion BOOLEAN DEFAULT FALSE,
    rol ENUM('admin', 'usuario') DEFAULT 'usuario',
    Tipo_cultivo VARCHAR(50),
    Hectareas INT,
    id_equipo INT,
    id_reportes INT,
    FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo),
    FOREIGN KEY (id_reportes) REFERENCES Reportes(id_reportes)
);

-- Tabla Reportes
CREATE TABLE IF NOT EXISTS Reportes (
    id_reportes INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(30) NOT NULL,
    tipo_reporte VARCHAR(30) NOT NULL,
    fecha_generacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('generado', 'enviado') DEFAULT 'generado',
    id_equipo INT,
    FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo)
);

-- Tabla Cultivo
CREATE TABLE IF NOT EXISTS Cultivo (
    id_cultivo INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    num_hectareas INT NOT NULL,
    id_equipos INT,
    FOREIGN KEY (id_equipos) REFERENCES Equipos(id_equipo)
);

-- Tabla Equipos
CREATE TABLE IF NOT EXISTS Equipos (
    id_equipo INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    cantidad INT NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo'
);

-- Tabla Sensores
CREATE TABLE IF NOT EXISTS Sensores (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(100) NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    id_equipo INT,
    FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo)
);

-- Tabla HistorialDatos
CREATE TABLE IF NOT EXISTS HistorialDatos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor FLOAT NOT NULL,
    FOREIGN KEY (id_sensor) REFERENCES Sensores(id_sensor)
);

-- Índices para mejorar el rendimiento de las consultas
CREATE INDEX idx_usuario_correo ON Usuario(correo_electronico);
CREATE INDEX idx_reporte_fecha ON Reportes(fecha_generacion);
CREATE INDEX idx_historial_fecha ON HistorialDatos(fecha);

-- Consideraciones de seguridad
-- Crear un usuario específico para la aplicación con permisos limitados
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON MonitoreoAgricola.* TO 'app_user'@'localhost';
FLUSH PRIVILEGES;

-- Ejemplo de inserción de datos iniciales (opcional)
INSERT INTO Equipos (tipo, cantidad) VALUES ('Estación Meteorológica', 1);
INSERT INTO Sensores (tipo, ubicacion, id_equipo) VALUES ('Humedad del Suelo', 'Campo Norte', 1);
