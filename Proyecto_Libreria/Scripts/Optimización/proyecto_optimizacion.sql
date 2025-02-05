 -- Optimización y Rendimiento de Consultas (tablas: ventas y reservas)
                                               
-- Índice en la columna id_cliente
CREATE INDEX idx_ventas_id_cliente ON ventas (id_cliente);

-- Índice en la columna id_libro
CREATE INDEX idx_ventas_id_libro ON ventas (id_libro);

-- Índice en la columna fecha_venta
CREATE INDEX idx_ventas_fecha_venta ON ventas (fecha_venta);

-- Índice en la columna id_cliente
CREATE INDEX idx_reservas_id_cliente ON reservas (id_cliente);

-- Índice en la columna fecha_reserva
CREATE INDEX idx_reservas_fecha_reserva ON reservas (fecha_reserva);

-- Verificar índices 
SHOW INDEX FROM ventas;
SHOW INDEX FROM reservas;
-- Buscar todas las ventas realizadas por un cliente específico
SELECT * FROM ventas WHERE id_cliente = 100;
-- Buscar todas las ventas de un libro específico
SELECT * FROM ventas WHERE id_libro = 310;
-- Buscar todas las ventas en un rango de fechas
SELECT * FROM ventas WHERE fecha_venta BETWEEN '2025-01-01' AND '2025-01-31';
SELECT * FROM reservas WHERE id_cliente = 102;

-- uso de explain
EXPLAIN 
SELECT 
    v.id_venta, c.nombre AS cliente, l.titulo AS libro, v.cantidad, v.total 
FROM 
    ventas v
JOIN 
    clientes c ON v.id_cliente = c.id_cliente
JOIN 
    libros l ON v.id_libro = l.id_libro
WHERE 
    v.total > 50;

-- particion de tabla
CREATE TABLE reservas_particionada (
    id_reserva INT NOT NULL,
    id_cliente INT,
    fecha_reserva DATE NOT NULL,
    cantidad INT NOT NULL,
    total DECIMAL(5,2),
    PRIMARY KEY (id_reserva, fecha_reserva)
) 
PARTITION BY RANGE (YEAR(fecha_reserva)) (
    PARTITION p_2023 VALUES LESS THAN (2024),
    PARTITION p_2024 VALUES LESS THAN (2025),
    PARTITION p_2025 VALUES LESS THAN (2026),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);
INSERT INTO reservas_particionada (id_reserva, id_cliente, fecha_reserva, cantidad, total)
VALUES
-- Partición p_2023
(1, 100, '2023-05-15', 3, 75.00),
(2, 101, '2023-10-20', 2, 50.00),
-- Partición p_2024
(3, 102, '2024-01-05', 1, 25.00),
(4, 103, '2024-06-15', 4, 100.00),
-- Partición p_2025
(5, 104, '2025-03-10', 2, 60.00),
-- Partición p_max (años superiores a 2025)
(6, 105, '2026-07-25', 1, 30.00);

SELECT * FROM reservas_particionada ORDER BY fecha_reserva;

SHOW PROCESSLIST;

-- identificar indices no utilizados

SHOW INDEX FROM ventas;
SHOW INDEX FROM reservas;

EXPLAIN 
SELECT * 
FROM ventas 
WHERE id_cliente = 100;

EXPLAIN 
SELECT * 
FROM reservas 
WHERE fecha_reserva BETWEEN '2025-01-01' AND '2025-01-31';