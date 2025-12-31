-- =========================================================
-- Base de datos: Sillas y Mesas Hernández
-- =========================================================

-- =========================
-- TABLAS BASE
-- =========================

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    correo VARCHAR(100)
);

CREATE TABLE Articulo (
    idArticulo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Disponible',
    cantidadTotal INT NOT NULL DEFAULT 0,
    cantidadDisponible INT NOT NULL DEFAULT 0,
    cantidadEnUso INT NOT NULL DEFAULT 0,
    cantidadDanada INT NOT NULL DEFAULT 0,
    costoRenta DECIMAL(10,2) NOT NULL
);

-- =========================
-- CLIENTES ESPECIALES
-- =========================

CREATE TABLE ClienteParticular (
    idCliente INT PRIMARY KEY,
    fechaNacimiento DATE,
    CURP VARCHAR(20),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE CASCADE
);

CREATE TABLE ClienteEmpresa (
    idCliente INT PRIMARY KEY,
    razonSocial VARCHAR(100),
    RFC VARCHAR(15),
    contactoEmpresa VARCHAR(100),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE CASCADE
);

CREATE TABLE Telefono (
    idTelefono INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    numero VARCHAR(15) NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE CASCADE
);

-- =========================
-- ARTICULOS ESPECIFICOS
-- =========================

CREATE TABLE Silla (
    idArticulo INT PRIMARY KEY,
    tipoSilla VARCHAR(50),
    material VARCHAR(50),
    FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo)
        ON DELETE CASCADE
);

CREATE TABLE Mesa (
    idArticulo INT PRIMARY KEY,
    forma VARCHAR(50),
    capacidadPersonas INT,
    tamano VARCHAR(50),
    FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo)
        ON DELETE CASCADE
);

CREATE TABLE Accesorio (
    idArticulo INT PRIMARY KEY,
    descripcion VARCHAR(100),
    fragilidad VARCHAR(30),
    FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo)
        ON DELETE CASCADE
);

-- =========================
-- PEDIDOS
-- =========================

CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    fechaPedido DATE,
    fechaEvento DATE NOT NULL,
    fechaEntrega DATE,
    fechaDevolucion DATE,
    montoTotal DECIMAL(10,2),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE CASCADE
);

CREATE TABLE DetallePedido (
    idPedido INT,
    idArticulo INT,
    cantidad INT NOT NULL,
    PRIMARY KEY (idPedido, idArticulo),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE,
    FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo)
        ON DELETE CASCADE
);

-- =========================
-- PAQUETES
-- =========================

CREATE TABLE Paquete (
    idPaquete INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precioEspecial DECIMAL(10,2)
);

CREATE TABLE PaqueteArticulo (
    idPaquete INT,
    idArticulo INT,
    cantidad INT NOT NULL,
    PRIMARY KEY (idPaquete, idArticulo),
    FOREIGN KEY (idPaquete) REFERENCES Paquete(idPaquete)
        ON DELETE CASCADE,
    FOREIGN KEY (idArticulo) REFERENCES Articulo(idArticulo)
        ON DELETE CASCADE
);

CREATE TABLE PedidoPaquete (
    idPedido INT,
    idPaquete INT,
    cantidad INT NOT NULL,
    PRIMARY KEY (idPedido, idPaquete),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE,
    FOREIGN KEY (idPaquete) REFERENCES Paquete(idPaquete)
        ON DELETE CASCADE
);

CREATE TABLE DetallePedidoPaquete (
    idPedido INT NOT NULL,
    idPaquete INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    PRIMARY KEY (idPedido, idPaquete),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE,
    FOREIGN KEY (idPaquete) REFERENCES Paquete(idPaquete)
        ON DELETE CASCADE
);

-- =========================
-- PAGOS Y USUARIOS
-- =========================

CREATE TABLE Pago (
    idPago INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT,
    fechaPago DATE,
    monto DECIMAL(10,2),
    estadoPago VARCHAR(20) DEFAULT 'Pendiente',
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE
);

CREATE TABLE Usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(20) DEFAULT 'admin'
);

-- =========================================================
-- POBLADO DE DATOS: Sillas y Mesas Hernández
-- =========================================================

-- 1. USUARIOS
INSERT INTO Usuario (nombreUsuario, contrasena, rol) VALUES 
('admin_juan', 'hash_pass_123', 'admin'),
('vendedor_ana', 'hash_pass_456', 'vendedor'),
('almacen_luis', 'hash_pass_789', 'almacen');

-- 2. CLIENTES (Base)
INSERT INTO Cliente (nombre, direccion, correo) VALUES 
('Juan Pérez', 'Av. Insurgentes 123, CDMX', 'juan.perez@email.com'),
('María García', 'Calle Reforma 45, CDMX', 'm.garcia@email.com'),
('Carlos López', 'Paseo de la Victoria 8, EdoMex', 'clopez@email.com'),
('Eventos Premium SA', 'Zona Industrial 500, CDMX', 'contacto@eventospremium.mx'),
('Banquetes Delicia', 'Col. Roma Sur 12, CDMX', 'ventas@banquetesdelicia.com'),
('Ana Martínez', 'Privada Sauces 4, CDMX', 'ana.mtz@email.com'),
('Roberto Gómez', 'Av. Juárez 90, CDMX', 'robert_g@email.com'),
('Hotel Grand Plaza', 'Av. Costera 20, Acapulco', 'info@grandplaza.com'),
('Laura Torres', 'Calle 10 num 45, EdoMex', 'laura_t@email.com'),
('Universidad del Valle', 'Campus Norte S/N, CDMX', 'servicios@uv.edu.mx');

-- 3. CLIENTES PARTICULARES
INSERT INTO ClienteParticular (idCliente, fechaNacimiento, CURP) VALUES 
(1, '1985-05-15', 'PEHJ850515HDFR'),
(2, '1990-11-20', 'GARM901120MDFR'),
(3, '1978-02-28', 'LOCC780228HDFR'),
(6, '1995-08-10', 'MAZA950810MDFR'),
(7, '1982-12-05', 'GORR821205HDFR'),
(9, '1988-03-22', 'TOAL880322MDFR');

-- 4. CLIENTES EMPRESA
INSERT INTO ClienteEmpresa (idCliente, razonSocial, RFC, contactoEmpresa) VALUES 
(4, 'Eventos Premium S.A. de C.V.', 'EPR120304ABC', 'Lic. Pedro Arce'),
(5, 'Banquetes y Delicias Gourmet', 'BDG050812XYZ', 'Chef Martha Ríos'),
(8, 'Hotelería y Turismo de México', 'HTM981010123', 'Gerente Recepción'),
(10, 'Educación Superior S.C.', 'ESS200101UV1', 'Ing. Ramiro Ruiz');

-- 5. TELÉFONOS
INSERT INTO Telefono (idCliente, numero) VALUES 
(1, '5512345678'), (1, '5598765432'), (2, '5522334455'), (3, '5566778899'),
(4, '5544001122'), (5, '5588990011'), (8, '7441234567'), (10, '5511223344');

-- 6. ARTÍCULOS (Base)
INSERT INTO Articulo (nombre, estado, cantidadTotal, cantidadDisponible, cantidadEnUso, cantidadDanada, costoRenta) VALUES 
('Silla Tiffany Blanca', 'Disponible', 200, 180, 15, 5, 25.50),
('Silla Plegable Negra', 'Disponible', 300, 250, 40, 10, 12.00),
('Silla Versalles Oro', 'Disponible', 150, 150, 0, 0, 35.00),
('Mesa Redonda 10 personas', 'Disponible', 50, 45, 4, 1, 150.00),
('Mesa Rectangular Tablón', 'Disponible', 40, 30, 8, 2, 120.00),
('Mesa de Cristal Cuadrada', 'Disponible', 20, 18, 2, 0, 250.00),
('Mantelería Blanca Lisa', 'Disponible', 100, 90, 10, 0, 45.00),
('Centro de Mesa Floral', 'Disponible', 60, 50, 10, 0, 80.00),
('Cubertería Plata Set', 'Disponible', 150, 140, 10, 0, 50.00),
('Plato Base Oro', 'Disponible', 200, 195, 5, 0, 15.00);

-- 7. SILLAS
INSERT INTO Silla (idArticulo, tipoSilla, material) VALUES 
(1, 'Tiffany', 'Madera/Resina'),
(2, 'Plegable', 'Plástico/Metal'),
(3, 'Versalles', 'Madera');

-- 8. MESAS
INSERT INTO Mesa (idArticulo, forma, capacidadPersonas, tamano) VALUES 
(4, 'Redonda', 10, '1.50m Diámetro'),
(5, 'Rectangular', 8, '2.40m x 0.75m'),
(6, 'Cuadrada', 4, '1.20m x 1.20m');

-- 9. ACCESORIOS
INSERT INTO Accesorio (idArticulo, descripcion, fragilidad) VALUES 
(7, 'Mantel de tela poliéster', 'Baja'),
(8, 'Arreglo con rosas naturales', 'Alta'),
(9, 'Set de 4 piezas (cuchara, tenedor, cuchillo)', 'Baja'),
(10, 'Plato decorativo para base', 'Media');

-- 10. PAQUETES
INSERT INTO Paquete (nombre, precioEspecial) VALUES 
('Boda Económica (50 pers)', 4500.00),
('Gala Empresarial (100 pers)', 9500.00),
('Cena Romántica (2 pers)', 850.00);

-- 11. CONTENIDO DE PAQUETES
INSERT INTO PaqueteArticulo (idPaquete, idArticulo, cantidad) VALUES 
(1, 1, 50), (1, 4, 5), (1, 7, 5), (2, 3, 100), (2, 4, 10), (2, 7, 10), (2, 9, 100), (3, 6, 1), (3, 3, 2), (3, 8, 1);

-- 12. PEDIDOS
INSERT INTO Pedido (idCliente, fechaPedido, fechaEvento, fechaEntrega, fechaDevolucion, montoTotal) VALUES 
(1, '2023-10-01', '2023-10-15', '2023-10-14', '2023-10-16', 1500.00),
(4, '2023-11-05', '2023-12-20', '2023-12-19', '2023-12-21', 12500.00),
(5, '2023-12-01', '2023-12-24', '2023-12-23', '2023-12-26', 8000.00),
(2, '2024-01-10', '2024-02-14', '2024-02-13', '2024-02-15', 2400.00);

-- 13. DETALLES DE PEDIDO
INSERT INTO DetallePedido (idPedido, idArticulo, cantidad) VALUES 
(1, 1, 20), (1, 5, 2), (2, 3, 100), (2, 10, 100), (3, 1, 50), (3, 4, 5);

-- 14. PAGOS
INSERT INTO Pago (idPedido, fechaPago, monto, estadoPago) VALUES 
(1, '2023-10-01', 500.00, 'Pagado'),
(1, '2023-10-14', 1000.00, 'Pagado'),
(2, '2023-11-05', 5000.00, 'Pagado'),
(2, '2023-12-19', 7500.00, 'Pagado'),
(3, '2023-12-01', 4000.00, 'Pagado'),
(4, '2024-01-10', 1200.00, 'Pendiente');

-- 15. MÁS CLIENTES (Para completar volumen)
INSERT INTO Cliente (nombre, direccion, correo) VALUES 
('Sofía Méndez', 'Col. Condesa, CDMX', 'sofia.m@email.com'),
('Ricardo Riva', 'Av. Central 44, EdoMex', 'rriva@email.com'),
('Eventos Sociales Paty', 'Calle 5 de Mayo, CDMX', 'paty_eventos@email.com'),
('Javier Ortiz', 'Lomas de Chapultepec, CDMX', 'j.ortiz@email.com'),
('Restaurante El Lago', 'Bosque de Chapultepec, CDMX', 'gerencia@ellago.mx');

INSERT INTO ClienteParticular (idCliente, fechaNacimiento, CURP) VALUES 
(11, '1992-06-12', 'MENS920612MDFR'),
(12, '1980-01-30', 'RIRR800130HDFR'),
(14, '1998-09-18', 'ORTR980918HDFR');

-- 16. MÁS ARTÍCULOS
INSERT INTO Articulo (nombre, estado, cantidadTotal, cantidadDisponible, cantidadEnUso, cantidadDanada, costoRenta) VALUES 
('Sombrilla Gigante Blanca', 'Disponible', 15, 15, 0, 0, 300.00),
('Calentador de Exterior', 'Disponible', 10, 8, 2, 0, 450.00),
('Silla Avant Garde Blanca', 'Disponible', 100, 100, 0, 0, 40.00),
('Mesa de Bar (Periquera)', 'Disponible', 20, 20, 0, 0, 180.00),
('Cristalería Copa Vino (Set 10)', 'Disponible', 50, 50, 0, 0, 120.00);

-- 17. MÁS PEDIDOS (Historial)
INSERT INTO Pedido (idCliente, fechaPedido, fechaEvento, fechaEntrega, fechaDevolucion, montoTotal) VALUES 
(11, '2024-02-01', '2024-02-10', '2024-02-09', '2024-02-11', 1800.00),
(12, '2024-02-05', '2024-02-20', '2024-02-19', '2024-02-21', 950.00),
(13, '2024-03-01', '2024-03-15', '2024-03-14', '2024-03-16', 5500.00),
(14, '2024-03-05', '2024-03-25', '2024-03-24', '2024-03-26', 1200.00),
(15, '2024-03-10', '2024-04-01', '2024-03-31', '2024-04-02', 15000.00),
(5, '2024-04-01', '2024-04-15', '2024-04-14', '2024-04-16', 3200.00);

-- 18. DETALLES DE PEDIDO
INSERT INTO DetallePedido (idPedido, idArticulo, cantidad) VALUES 
(5, 1, 30), (5, 4, 3), (5, 7, 3), (5, 10, 30),
(6, 11, 2), (6, 14, 4),
(7, 13, 50), (7, 15, 5),
(8, 1, 20), (8, 11, 2),
(9, 3, 200), (9, 4, 20), (9, 7, 20), (9, 9, 20), (9, 10, 20),
(10, 1, 50), (10, 7, 10);

-- 19. MÁS PAGOS
INSERT INTO Pago (idPedido, fechaPago, monto, estadoPago) VALUES 
(5, '2024-02-01', 1800.00, 'Pagado'),
(6, '2024-02-05', 950.00, 'Pagado'),
(7, '2024-03-01', 2000.00, 'Pagado'),
(8, '2024-03-05', 1200.00, 'Pagado');