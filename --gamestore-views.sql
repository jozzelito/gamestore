CREATE DATABASE gamestore;
USE gamestore;

-- 1. TABLES --
-- ## TABLE 1: ROLES
CREATE TABLE roles (
    role_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name   VARCHAR(50)  NOT NULL,
    description VARCHAR(255),
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    role_status ENUM('active','inactive') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_roles_name UNIQUE (role_name)
);
 
-- ## TALBE 2: STABLISHMENT
CREATE TABLE stablishment (
    stablishment_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stablishment_name   VARCHAR(100) NOT NULL,
    address             VARCHAR(255) NOT NULL,
    city                VARCHAR(100) NOT NULL,
    state               VARCHAR(100),
    country             VARCHAR(100) NOT NULL DEFAULT 'USA',
    phone               VARCHAR(20),
    email               VARCHAR(100),
    created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    stablishment_status ENUM('active','inactive','suspended') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_stablishment_name UNIQUE (stablishment_name)
);
 
-- ## TABLE 3: EMPLOYEES
CREATE TABLE employees (
    employee_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stablishment_id INT UNSIGNED NOT NULL,
    role_id         INT UNSIGNED NOT NULL,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL,
    phone           VARCHAR(20),
    hire_date       DATE         NOT NULL,
    salary          DECIMAL(10,2),
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    employee_status ENUM('active','inactive','suspended','on_leave') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_employees_email    UNIQUE (email),
    CONSTRAINT uq_employees_fullname UNIQUE (first_name, last_name),
    CONSTRAINT fk_employees_stablishment FOREIGN KEY (stablishment_id) REFERENCES stablishment(stablishment_id),
    CONSTRAINT fk_employees_role         FOREIGN KEY (role_id)         REFERENCES roles(role_id)
);
 
-- ## TABLE 4: CLIENTS
CREATE TABLE clients (
    client_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    phone         VARCHAR(20),
    birthdate     DATE,
    address       VARCHAR(255),
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    client_status ENUM('active','inactive','banned') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_clients_email    UNIQUE (email),
    CONSTRAINT uq_clients_fullname UNIQUE (first_name, last_name)
);
 
-- ## TALBE 5: SUPPLIERS
CREATE TABLE suppliers (
    supplier_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    supplier_name   VARCHAR(150) NOT NULL,
    contact_name    VARCHAR(150),
    email           VARCHAR(150),
    phone           VARCHAR(20),
    address         VARCHAR(255),
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    supplier_status ENUM('active','inactive','suspended') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_suppliers_name UNIQUE (supplier_name)
);
 
-- ## TALBE 6: CONSOLES
CREATE TABLE consoles (
    console_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    console_name   VARCHAR(100) NOT NULL,
    manufacturer   VARCHAR(100),
    release_year   YEAR,
    created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    console_status ENUM('active','inactive','discontinued') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_consoles_name UNIQUE (console_name)
);
 
-- ## TABLE 7: CATEGORIES
CREATE TABLE categories (
    category_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category_name   VARCHAR(100) NOT NULL,
    description     VARCHAR(255),
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    category_status ENUM('active','inactive') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_categories_name UNIQUE (category_name)
);
 
-- ## TABLE 8: GAMES
CREATE TABLE games (
    game_id      INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    console_id   INT UNSIGNED  NOT NULL,
    category_id  INT UNSIGNED  NOT NULL,
    supplier_id  INT UNSIGNED,
    game_name    VARCHAR(200)  NOT NULL,
    developer    VARCHAR(150),
    publisher    VARCHAR(150),
    release_date DATE,
    price        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    description  TEXT,
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    game_status  ENUM('active','inactive','discontinued','out_of_stock') NOT NULL DEFAULT 'active',
    CONSTRAINT uq_games_name_console UNIQUE (game_name, console_id),
    CONSTRAINT fk_games_console  FOREIGN KEY (console_id)  REFERENCES consoles(console_id),
    CONSTRAINT fk_games_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_games_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);
 
-- ## TALBE 9: INVENTORY
CREATE TABLE inventory (
    inventory_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    game_id         INT UNSIGNED NOT NULL,
    stablishment_id INT UNSIGNED NOT NULL,
    quantity        INT          NOT NULL DEFAULT 0,
    min_stock       INT          NOT NULL DEFAULT 5,
    last_restocked  DATETIME,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_inventory_game_store   UNIQUE (game_id, stablishment_id),
    CONSTRAINT fk_inventory_game         FOREIGN KEY (game_id)         REFERENCES games(game_id),
    CONSTRAINT fk_inventory_stablishment FOREIGN KEY (stablishment_id) REFERENCES stablishment(stablishment_id),
    CONSTRAINT chk_inventory_quantity    CHECK (quantity >= 0)
);
 
-- ## TABLE 10: BILL
CREATE TABLE bill (
    bill_id         INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    client_id       INT UNSIGNED  NOT NULL,
    employee_id     INT UNSIGNED  NOT NULL,
    stablishment_id INT UNSIGNED  NOT NULL,
    bill_date       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount    DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    payment_method  ENUM('cash','card','transfer','other') NOT NULL DEFAULT 'cash',
    status          ENUM('pending','completed','cancelled','refunded') NOT NULL DEFAULT 'completed',
    notes           TEXT,
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_bill_client       FOREIGN KEY (client_id)       REFERENCES clients(client_id),
    CONSTRAINT fk_bill_employee     FOREIGN KEY (employee_id)     REFERENCES employees(employee_id),
    CONSTRAINT fk_bill_stablishment FOREIGN KEY (stablishment_id) REFERENCES stablishment(stablishment_id)
);
 
-- ## TABLE 11: BILL DETAILS
CREATE TABLE bill_details (
    detail_id  INT UNSIGNED  AUTO_INCREMENT PRIMARY KEY,
    bill_id    INT UNSIGNED  NOT NULL,
    game_id    INT UNSIGNED  NOT NULL,
    quantity   INT           NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal   DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    CONSTRAINT fk_detail_bill FOREIGN KEY (bill_id) REFERENCES bill(bill_id),
    CONSTRAINT fk_detail_game FOREIGN KEY (game_id) REFERENCES games(game_id),
    CONSTRAINT chk_detail_qty CHECK (quantity > 0)
);

create view juegos_completos AS
select
g.game_id,
g.game_name,
c.console_name,
cat.category_name,
g.developer,
g.publisher,
g.release_date,
g.price,
s.supplier_name,
g.description as game_description,
g.game_status

from games g
left join consoles c on g.console_id = c.console_id
left join categories cat on g.category_id
left join suppliers s on g.supplier_id = s.supplier_id;

 
