CREATE DATABASE IF NOT EXISTS bolsa_empleo
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bolsa_empleo;

-- ------------------------------------------------------------
-- ADMINISTRADORES
-- ------------------------------------------------------------
CREATE TABLE administrador (
                               id           INT AUTO_INCREMENT PRIMARY KEY,
                               identificacion VARCHAR(20) NOT NULL UNIQUE,
                               nombre       VARCHAR(100) NOT NULL,
                               clave        VARCHAR(255) NOT NULL   -- BCrypt hash
);

-- ------------------------------------------------------------
-- EMPRESAS
-- ------------------------------------------------------------
CREATE TABLE empresa (
                         id           INT AUTO_INCREMENT PRIMARY KEY,
                         nombre       VARCHAR(150) NOT NULL,
                         localizacion VARCHAR(200),
                         correo       VARCHAR(150) NOT NULL UNIQUE,
                         telefono     VARCHAR(20),
                         descripcion  TEXT,
                         clave        VARCHAR(255) NOT NULL,  -- BCrypt hash
                         aprobada     BOOLEAN NOT NULL DEFAULT FALSE,
                         activa       BOOLEAN NOT NULL DEFAULT TRUE,
                         fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- OFERENTES
-- ------------------------------------------------------------
CREATE TABLE oferente (
                          id              INT AUTO_INCREMENT PRIMARY KEY,
                          identificacion  VARCHAR(20) NOT NULL UNIQUE,
                          nombre          VARCHAR(100) NOT NULL,
                          primer_apellido VARCHAR(100) NOT NULL,
                          nacionalidad    VARCHAR(80),
                          telefono        VARCHAR(20),
                          correo          VARCHAR(150) NOT NULL UNIQUE,
                          residencia      VARCHAR(200),
                          clave           VARCHAR(255) NOT NULL,  -- BCrypt hash
                          curriculum_pdf  VARCHAR(300),           -- ruta al archivo PDF
                          aprobado        BOOLEAN NOT NULL DEFAULT FALSE,
                          activo          BOOLEAN NOT NULL DEFAULT TRUE,
                          fecha_registro  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- CARACTERÍSTICAS (jerárquicas)
-- ------------------------------------------------------------
CREATE TABLE caracteristica (
                                id        INT AUTO_INCREMENT PRIMARY KEY,
                                nombre    VARCHAR(100) NOT NULL,
                                padre_id  INT NULL,
                                CONSTRAINT fk_carac_padre FOREIGN KEY (padre_id)
                                    REFERENCES caracteristica(id) ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- PUESTOS
-- ------------------------------------------------------------
CREATE TABLE puesto (
                        id          INT AUTO_INCREMENT PRIMARY KEY,
                        empresa_id  INT NOT NULL,
                        descripcion TEXT NOT NULL,
                        salario     DECIMAL(12,2) NOT NULL,
                        es_publico  BOOLEAN NOT NULL DEFAULT TRUE,
                        activo      BOOLEAN NOT NULL DEFAULT TRUE,
                        fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        CONSTRAINT fk_puesto_empresa FOREIGN KEY (empresa_id)
                            REFERENCES empresa(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- REQUISITOS DEL PUESTO  (característica + nivel mínimo)
-- ------------------------------------------------------------
CREATE TABLE puesto_caracteristica (
                                       id               INT AUTO_INCREMENT PRIMARY KEY,
                                       puesto_id        INT NOT NULL,
                                       caracteristica_id INT NOT NULL,
                                       nivel_requerido  TINYINT NOT NULL DEFAULT 1,   -- 1-5
                                       CONSTRAINT fk_pc_puesto FOREIGN KEY (puesto_id)
                                           REFERENCES puesto(id) ON DELETE CASCADE,
                                       CONSTRAINT fk_pc_carac  FOREIGN KEY (caracteristica_id)
                                           REFERENCES caracteristica(id) ON DELETE RESTRICT,
                                       UNIQUE KEY uq_puesto_carac (puesto_id, caracteristica_id)
);

-- ------------------------------------------------------------
-- HABILIDADES DEL OFERENTE  (característica + nivel que tiene)
-- ------------------------------------------------------------
CREATE TABLE oferente_habilidad (
                                    id               INT AUTO_INCREMENT PRIMARY KEY,
                                    oferente_id      INT NOT NULL,
                                    caracteristica_id INT NOT NULL,
                                    nivel            TINYINT NOT NULL DEFAULT 1,   -- 1-5
                                    CONSTRAINT fk_oh_oferente FOREIGN KEY (oferente_id)
                                        REFERENCES oferente(id) ON DELETE CASCADE,
                                    CONSTRAINT fk_oh_carac    FOREIGN KEY (caracteristica_id)
                                        REFERENCES caracteristica(id) ON DELETE RESTRICT,
                                    UNIQUE KEY uq_oferente_carac (oferente_id, caracteristica_id)
);

-- ============================================================
-- DATOS INICIALES
-- ============================================================

-- Administrador por defecto  (clave: admin123)
INSERT INTO administrador (identificacion, nombre, clave) VALUES
    ('00000000', 'Administrador',
     '$2a$10$Ow3eRC8R1/k5q5n9.QwLmOVXz0YEi4Q8YrFp4oGJ7OkL6k3/nS9Oi');

-- Características de ejemplo
INSERT INTO caracteristica (id, nombre, padre_id) VALUES
                                                      (1,  'Bases de Datos',            NULL),
                                                      (2,  'Motores',                   1),
                                                      (3,  'MySql',                     2),
                                                      (4,  'Oracle',                    2),
                                                      (5,  'Ciberseguridad',            NULL),
                                                      (6,  'Lenguajes de programación', NULL),
                                                      (7,  'C#',                        6),
                                                      (8,  'Java',                      6),
                                                      (9,  'Kotlin',                    6),
                                                      (10, 'Tecnologías Web',           NULL),
                                                      (11, 'HTML',                      10),
                                                      (12, 'CSS',                       10),
                                                      (13, 'JavaScript',                10),
                                                      (14, 'Testing',                   NULL),
                                                      (15, 'JUnit',                     14),
                                                      (16, 'Assertions',                15),
                                                      (17, 'Test cases',                15);