CREATE DATABASE gamestore;
USE gamestore;

-- 1. TABLES --
-- ## TABLE 1: ROLES
CREATE TABLE roles (
    role_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_name   VARCHAR(255)  NOT NULL,
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

-- ## TABLE 12: AUDIT_LOG 
CREATE TABLE audit_log (
    audit_id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    table_name      VARCHAR(50) NOT NULL,
    operation       ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id       INT UNSIGNED NOT NULL,
    old_data        JSON,
    new_data        JSON,
    changed_by      VARCHAR(100),
    changed_by_id   INT UNSIGNED,
    changed_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address      VARCHAR(45),
    user_agent      TEXT,
    CONSTRAINT idx_audit_table_record UNIQUE (table_name, operation, record_id, changed_at)
);

-- 2. TRIGGERS --
-- ## TRIGGER 1: ROLES
CREATE TRIGGER roles_audit_insert
AFTER INSERT ON roles
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('roles', 'INSERT', NEW.role_id, JSON_OBJECT('role_id', NEW.role_id, 'role_name', NEW.role_name, 'description', NEW.description, 'role_status', NEW.role_status), USER(), NOW());

CREATE TRIGGER roles_audit_update
AFTER UPDATE ON roles
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('roles', 'UPDATE', NEW.role_id, 
        JSON_OBJECT('role_id', OLD.role_id, 'role_name', OLD.role_name, 'description', OLD.description, 'role_status', OLD.role_status),
        JSON_OBJECT('role_id', NEW.role_id, 'role_name', NEW.role_name, 'description', NEW.description, 'role_status', NEW.role_status),
        USER(), NOW());

CREATE TRIGGER roles_audit_delete
AFTER DELETE ON roles
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('roles', 'DELETE', OLD.role_id, 
        JSON_OBJECT('role_id', OLD.role_id, 'role_name', OLD.role_name, 'description', OLD.description, 'role_status', OLD.role_status),
        USER(), NOW());

-- ## TRIGGER 2: STABLISHMENT
CREATE TRIGGER stablishment_audit_insert
AFTER INSERT ON stablishment
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('stablishment', 'INSERT', NEW.stablishment_id, 
        JSON_OBJECT('stablishment_id', NEW.stablishment_id, 'stablishment_name', NEW.stablishment_name, 'address', NEW.address, 'city', NEW.city, 'state', NEW.state, 'country', NEW.country, 'phone', NEW.phone, 'email', NEW.email, 'stablishment_status', NEW.stablishment_status),
        USER(), NOW());

CREATE TRIGGER stablishment_audit_update
AFTER UPDATE ON stablishment
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('stablishment', 'UPDATE', NEW.stablishment_id,
        JSON_OBJECT('stablishment_id', OLD.stablishment_id, 'stablishment_name', OLD.stablishment_name, 'address', OLD.address, 'city', OLD.city, 'state', OLD.state, 'country', OLD.country, 'phone', OLD.phone, 'email', OLD.email, 'stablishment_status', OLD.stablishment_status),
        JSON_OBJECT('stablishment_id', NEW.stablishment_id, 'stablishment_name', NEW.stablishment_name, 'address', NEW.address, 'city', NEW.city, 'state', NEW.state, 'country', NEW.country, 'phone', NEW.phone, 'email', NEW.email, 'stablishment_status', NEW.stablishment_status),
        USER(), NOW());

CREATE TRIGGER stablishment_audit_delete
AFTER DELETE ON stablishment
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('stablishment', 'DELETE', OLD.stablishment_id,
        JSON_OBJECT('stablishment_id', OLD.stablishment_id, 'stablishment_name', OLD.stablishment_name, 'address', OLD.address, 'city', OLD.city, 'state', OLD.state, 'country', OLD.country, 'phone', OLD.phone, 'email', OLD.email, 'stablishment_status', OLD.stablishment_status),
        USER(), NOW());

-- ## TRIGGER 3: EMPLOYEES
CREATE TRIGGER employees_audit_insert
AFTER INSERT ON employees
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('employees', 'INSERT', NEW.employee_id,
        JSON_OBJECT('employee_id', NEW.employee_id, 'stablishment_id', NEW.stablishment_id, 'role_id', NEW.role_id, 'first_name', NEW.first_name, 'last_name', NEW.last_name, 'email', NEW.email, 'phone', NEW.phone, 'hire_date', NEW.hire_date, 'salary', NEW.salary, 'employee_status', NEW.employee_status),
        USER(), NOW());

CREATE TRIGGER employees_audit_update
AFTER UPDATE ON employees
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('employees', 'UPDATE', NEW.employee_id,
        JSON_OBJECT('employee_id', OLD.employee_id, 'stablishment_id', OLD.stablishment_id, 'role_id', OLD.role_id, 'first_name', OLD.first_name, 'last_name', OLD.last_name, 'email', OLD.email, 'phone', OLD.phone, 'hire_date', OLD.hire_date, 'salary', OLD.salary, 'employee_status', OLD.employee_status),
        JSON_OBJECT('employee_id', NEW.employee_id, 'stablishment_id', NEW.stablishment_id, 'role_id', NEW.role_id, 'first_name', NEW.first_name, 'last_name', NEW.last_name, 'email', NEW.email, 'phone', NEW.phone, 'hire_date', NEW.hire_date, 'salary', NEW.salary, 'employee_status', NEW.employee_status),
        USER(), NOW());

CREATE TRIGGER employees_audit_delete
AFTER DELETE ON employees
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('employees', 'DELETE', OLD.employee_id,
        JSON_OBJECT('employee_id', OLD.employee_id, 'stablishment_id', OLD.stablishment_id, 'role_id', OLD.role_id, 'first_name', OLD.first_name, 'last_name', OLD.last_name, 'email', OLD.email, 'phone', OLD.phone, 'hire_date', OLD.hire_date, 'salary', OLD.salary, 'employee_status', OLD.employee_status),
        USER(), NOW());

-- ## TRIGGER 4: CLIENTS
CREATE TRIGGER clients_audit_insert
AFTER INSERT ON clients
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('clients', 'INSERT', NEW.client_id,
        JSON_OBJECT('client_id', NEW.client_id, 'first_name', NEW.first_name, 'last_name', NEW.last_name, 'email', NEW.email, 'phone', NEW.phone, 'birthdate', NEW.birthdate, 'address', NEW.address, 'client_status', NEW.client_status),
        USER(), NOW());

CREATE TRIGGER clients_audit_update
AFTER UPDATE ON clients
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('clients', 'UPDATE', NEW.client_id,
        JSON_OBJECT('client_id', OLD.client_id, 'first_name', OLD.first_name, 'last_name', OLD.last_name, 'email', OLD.email, 'phone', OLD.phone, 'birthdate', OLD.birthdate, 'address', OLD.address, 'client_status', OLD.client_status),
        JSON_OBJECT('client_id', NEW.client_id, 'first_name', NEW.first_name, 'last_name', NEW.last_name, 'email', NEW.email, 'phone', NEW.phone, 'birthdate', NEW.birthdate, 'address', NEW.address, 'client_status', NEW.client_status),
        USER(), NOW());

CREATE TRIGGER clients_audit_delete
AFTER DELETE ON clients
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('clients', 'DELETE', OLD.client_id,
        JSON_OBJECT('client_id', OLD.client_id, 'first_name', OLD.first_name, 'last_name', OLD.last_name, 'email', OLD.email, 'phone', OLD.phone, 'birthdate', OLD.birthdate, 'address', OLD.address, 'client_status', OLD.client_status),
        USER(), NOW());

-- ## TRIGGER 5: SUPPLIERS
CREATE TRIGGER suppliers_audit_insert
AFTER INSERT ON suppliers
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('suppliers', 'INSERT', NEW.supplier_id,
        JSON_OBJECT('supplier_id', NEW.supplier_id, 'supplier_name', NEW.supplier_name, 'contact_name', NEW.contact_name, 'email', NEW.email, 'phone', NEW.phone, 'address', NEW.address, 'supplier_status', NEW.supplier_status),
        USER(), NOW());

CREATE TRIGGER suppliers_audit_update
AFTER UPDATE ON suppliers
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('suppliers', 'UPDATE', NEW.supplier_id,
        JSON_OBJECT('supplier_id', OLD.supplier_id, 'supplier_name', OLD.supplier_name, 'contact_name', OLD.contact_name, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address, 'supplier_status', OLD.supplier_status),
        JSON_OBJECT('supplier_id', NEW.supplier_id, 'supplier_name', NEW.supplier_name, 'contact_name', NEW.contact_name, 'email', NEW.email, 'phone', NEW.phone, 'address', NEW.address, 'supplier_status', NEW.supplier_status),
        USER(), NOW());

CREATE TRIGGER suppliers_audit_delete
AFTER DELETE ON suppliers
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('suppliers', 'DELETE', OLD.supplier_id,
        JSON_OBJECT('supplier_id', OLD.supplier_id, 'supplier_name', OLD.supplier_name, 'contact_name', OLD.contact_name, 'email', OLD.email, 'phone', OLD.phone, 'address', OLD.address, 'supplier_status', OLD.supplier_status),
        USER(), NOW());

-- ## TRIGGER 6: CONSOLES
CREATE TRIGGER consoles_audit_insert
AFTER INSERT ON consoles
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('consoles', 'INSERT', NEW.console_id,
        JSON_OBJECT('console_id', NEW.console_id, 'console_name', NEW.console_name, 'manufacturer', NEW.manufacturer, 'release_year', NEW.release_year, 'console_status', NEW.console_status),
        USER(), NOW());

CREATE TRIGGER consoles_audit_update
AFTER UPDATE ON consoles
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('consoles', 'UPDATE', NEW.console_id,
        JSON_OBJECT('console_id', OLD.console_id, 'console_name', OLD.console_name, 'manufacturer', OLD.manufacturer, 'release_year', OLD.release_year, 'console_status', OLD.console_status),
        JSON_OBJECT('console_id', NEW.console_id, 'console_name', NEW.console_name, 'manufacturer', NEW.manufacturer, 'release_year', NEW.release_year, 'console_status', NEW.console_status),
        USER(), NOW());

CREATE TRIGGER consoles_audit_delete
AFTER DELETE ON consoles
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('consoles', 'DELETE', OLD.console_id,
        JSON_OBJECT('console_id', OLD.console_id, 'console_name', OLD.console_name, 'manufacturer', OLD.manufacturer, 'release_year', OLD.release_year, 'console_status', OLD.console_status),
        USER(), NOW());

-- ## TRIGGER 7: CATEGORIES
CREATE TRIGGER categories_audit_insert
AFTER INSERT ON categories
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('categories', 'INSERT', NEW.category_id,
        JSON_OBJECT('category_id', NEW.category_id, 'category_name', NEW.category_name, 'description', NEW.description, 'category_status', NEW.category_status),
        USER(), NOW());

CREATE TRIGGER categories_audit_update
AFTER UPDATE ON categories
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('categories', 'UPDATE', NEW.category_id,
        JSON_OBJECT('category_id', OLD.category_id, 'category_name', OLD.category_name, 'description', OLD.description, 'category_status', OLD.category_status),
        JSON_OBJECT('category_id', NEW.category_id, 'category_name', NEW.category_name, 'description', NEW.description, 'category_status', NEW.category_status),
        USER(), NOW());

CREATE TRIGGER categories_audit_delete
AFTER DELETE ON categories
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('categories', 'DELETE', OLD.category_id,
        JSON_OBJECT('category_id', OLD.category_id, 'category_name', OLD.category_name, 'description', OLD.description, 'category_status', OLD.category_status),
        USER(), NOW());

-- ## TRIGGER 8: GAMES
CREATE TRIGGER games_audit_insert
AFTER INSERT ON games
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('games', 'INSERT', NEW.game_id,
        JSON_OBJECT('game_id', NEW.game_id, 'console_id', NEW.console_id, 'category_id', NEW.category_id, 'supplier_id', NEW.supplier_id, 'game_name', NEW.game_name, 'developer', NEW.developer, 'publisher', NEW.publisher, 'release_date', NEW.release_date, 'price', NEW.price, 'description', NEW.description, 'game_status', NEW.game_status),
        USER(), NOW());

CREATE TRIGGER games_audit_update
AFTER UPDATE ON games
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('games', 'UPDATE', NEW.game_id,
        JSON_OBJECT('game_id', OLD.game_id, 'console_id', OLD.console_id, 'category_id', OLD.category_id, 'supplier_id', OLD.supplier_id, 'game_name', OLD.game_name, 'developer', OLD.developer, 'publisher', OLD.publisher, 'release_date', OLD.release_date, 'price', OLD.price, 'description', OLD.description, 'game_status', OLD.game_status),
        JSON_OBJECT('game_id', NEW.game_id, 'console_id', NEW.console_id, 'category_id', NEW.category_id, 'supplier_id', NEW.supplier_id, 'game_name', NEW.game_name, 'developer', NEW.developer, 'publisher', NEW.publisher, 'release_date', NEW.release_date, 'price', NEW.price, 'description', NEW.description, 'game_status', NEW.game_status),
        USER(), NOW());

CREATE TRIGGER games_audit_delete
AFTER DELETE ON games
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('games', 'DELETE', OLD.game_id,
        JSON_OBJECT('game_id', OLD.game_id, 'console_id', OLD.console_id, 'category_id', OLD.category_id, 'supplier_id', OLD.supplier_id, 'game_name', OLD.game_name, 'developer', OLD.developer, 'publisher', OLD.publisher, 'release_date', OLD.release_date, 'price', OLD.price, 'description', OLD.description, 'game_status', OLD.game_status),
        USER(), NOW());

-- ## TRIGGER 9: INVENTORY
CREATE TRIGGER inventory_audit_insert
AFTER INSERT ON inventory
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('inventory', 'INSERT', NEW.inventory_id,
        JSON_OBJECT('inventory_id', NEW.inventory_id, 'game_id', NEW.game_id, 'stablishment_id', NEW.stablishment_id, 'quantity', NEW.quantity, 'min_stock', NEW.min_stock, 'last_restocked', NEW.last_restocked),
        USER(), NOW());

CREATE TRIGGER inventory_audit_update
AFTER UPDATE ON inventory
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('inventory', 'UPDATE', NEW.inventory_id,
        JSON_OBJECT('inventory_id', OLD.inventory_id, 'game_id', OLD.game_id, 'stablishment_id', OLD.stablishment_id, 'quantity', OLD.quantity, 'min_stock', OLD.min_stock, 'last_restocked', OLD.last_restocked),
        JSON_OBJECT('inventory_id', NEW.inventory_id, 'game_id', NEW.game_id, 'stablishment_id', NEW.stablishment_id, 'quantity', NEW.quantity, 'min_stock', NEW.min_stock, 'last_restocked', NEW.last_restocked),
        USER(), NOW());

CREATE TRIGGER inventory_audit_delete
AFTER DELETE ON inventory
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('inventory', 'DELETE', OLD.inventory_id,
        JSON_OBJECT('inventory_id', OLD.inventory_id, 'game_id', OLD.game_id, 'stablishment_id', OLD.stablishment_id, 'quantity', OLD.quantity, 'min_stock', OLD.min_stock, 'last_restocked', OLD.last_restocked),
        USER(), NOW());

-- ## TRIGGER 10: BILL
CREATE TRIGGER bill_audit_insert
AFTER INSERT ON bill
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('bill', 'INSERT', NEW.bill_id,
        JSON_OBJECT('bill_id', NEW.bill_id, 'client_id', NEW.client_id, 'employee_id', NEW.employee_id, 'stablishment_id', NEW.stablishment_id, 'bill_date', NEW.bill_date, 'total_amount', NEW.total_amount, 'payment_method', NEW.payment_method, 'status', NEW.status, 'notes', NEW.notes),
        USER(), NOW());

CREATE TRIGGER bill_audit_update
AFTER UPDATE ON bill
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('bill', 'UPDATE', NEW.bill_id,
        JSON_OBJECT('bill_id', OLD.bill_id, 'client_id', OLD.client_id, 'employee_id', OLD.employee_id, 'stablishment_id', OLD.stablishment_id, 'bill_date', OLD.bill_date, 'total_amount', OLD.total_amount, 'payment_method', OLD.payment_method, 'status', OLD.status, 'notes', OLD.notes),
        JSON_OBJECT('bill_id', NEW.bill_id, 'client_id', NEW.client_id, 'employee_id', NEW.employee_id, 'stablishment_id', NEW.stablishment_id, 'bill_date', NEW.bill_date, 'total_amount', NEW.total_amount, 'payment_method', NEW.payment_method, 'status', NEW.status, 'notes', NEW.notes),
        USER(), NOW());

CREATE TRIGGER bill_audit_delete
AFTER DELETE ON bill
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('bill', 'DELETE', OLD.bill_id,
        JSON_OBJECT('bill_id', OLD.bill_id, 'client_id', OLD.client_id, 'employee_id', OLD.employee_id, 'stablishment_id', OLD.stablishment_id, 'bill_date', OLD.bill_date, 'total_amount', OLD.total_amount, 'payment_method', OLD.payment_method, 'status', OLD.status, 'notes', OLD.notes),
        USER(), NOW());

-- ## TRIGGER 11: BILL DETAILS
CREATE TRIGGER bill_details_audit_insert
AFTER INSERT ON bill_details
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, new_data, changed_by, changed_at)
VALUES ('bill_details', 'INSERT', NEW.detail_id,
        JSON_OBJECT('detail_id', NEW.detail_id, 'bill_id', NEW.bill_id, 'game_id', NEW.game_id, 'quantity', NEW.quantity, 'unit_price', NEW.unit_price, 'subtotal', NEW.subtotal),
        USER(), NOW());

CREATE TRIGGER bill_details_audit_update
AFTER UPDATE ON bill_details
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_at)
VALUES ('bill_details', 'UPDATE', NEW.detail_id,
        JSON_OBJECT('detail_id', OLD.detail_id, 'bill_id', OLD.bill_id, 'game_id', OLD.game_id, 'quantity', OLD.quantity, 'unit_price', OLD.unit_price, 'subtotal', OLD.subtotal),
        JSON_OBJECT('detail_id', NEW.detail_id, 'bill_id', NEW.bill_id, 'game_id', NEW.game_id, 'quantity', NEW.quantity, 'unit_price', NEW.unit_price, 'subtotal', NEW.subtotal),
        USER(), NOW());

CREATE TRIGGER bill_details_audit_delete
AFTER DELETE ON bill_details
FOR EACH ROW
INSERT INTO audit_log (table_name, operation, record_id, old_data, changed_by, changed_at)
VALUES ('bill_details', 'DELETE', OLD.detail_id,
        JSON_OBJECT('detail_id', OLD.detail_id, 'bill_id', OLD.bill_id, 'game_id', OLD.game_id, 'quantity', OLD.quantity, 'unit_price', OLD.unit_price, 'subtotal', OLD.subtotal),
        USER(), NOW());

-- 3. DATA INSERT --
-- 1. ROLES
INSERT INTO roles (role_name, description, role_status) VALUES
('Cashier', 'Handles sales', 'active'),
('Inventory Clerk', 'Manages inventory', 'active'),
('Administrator',         'Full system access', 'active'),
('Store Manager', 'Manages store operations', 'active'),
('Supervisor',    'Oversees store operations', 'active');

-- 2. STABLISHMENT (10 sucursales)
INSERT INTO stablishment (stablishment_name, address, city, state, country, phone, email, stablishment_status) VALUES
('GameStore Downtown', '123 Main St', 'New York', 'NY', 'USA', '212-555-0101', 'downtown@gamestore.com', 'active'),
('GameStore Westside', '456 West Ave', 'Los Angeles', 'CA', 'USA', '310-555-0102', 'westside@gamestore.com', 'active'),
('GameStore North Mall', '789 North Blvd', 'Chicago', 'IL', 'USA', '312-555-0103', 'northmall@gamestore.com', 'active'),
('GameStore South Park', '321 South St', 'Houston', 'TX', 'USA', '713-555-0104', 'southpark@gamestore.com', 'active'),
('GameStore Eastside', '654 East Rd', 'Miami', 'FL', 'USA', '305-555-0105', 'eastside@gamestore.com', 'active'),
('GameStore Central Plaza', '987 Central Ave', 'Dallas', 'TX', 'USA', '214-555-0106', 'central@gamestore.com', 'active'),
('GameStore Bay Area', '147 Bay St', 'San Francisco', 'CA', 'USA', '415-555-0107', 'bayarea@gamestore.com', 'active'),
('GameStore Seattle', '258 Pike St', 'Seattle', 'WA', 'USA', '206-555-0108', 'seattle@gamestore.com', 'active'),
('GameStore Boston', '369 Commonwealth Ave', 'Boston', 'MA', 'USA', '617-555-0109', 'boston@gamestore.com', 'active'),
('GameStore Denver', '741 Colorado Blvd', 'Denver', 'CO', 'USA', '303-555-0110', 'denver@gamestore.com', 'active');

-- 3. EMPLOYEES (30 empleados)
INSERT INTO employees (stablishment_id, role_id, first_name, last_name, email, phone, hire_date, salary, employee_status) VALUES
(1, 1, 'John', 'Smith', 'john.smith@gamestore.com', '212-555-1001', '2020-01-15', 65000.00, 'active'),
(1, 2, 'Sarah', 'Johnson', 'sarah.johnson@gamestore.com', '212-555-1002', '2021-03-10', 55000.00, 'active'),
(1, 3, 'Michael', 'Brown', 'michael.brown@gamestore.com', '212-555-1003', '2022-01-20', 35000.00, 'active'),
(2, 2, 'David', 'Wilson', 'david.wilson@gamestore.com', '310-555-2001', '2020-05-20', 56000.00, 'active'),
(2, 3, 'Lisa', 'Martinez', 'lisa.martinez@gamestore.com', '310-555-2002', '2021-08-10', 36000.00, 'active'),
(2, 3, 'James', 'Garcia', 'james.garcia@gamestore.com', '310-555-2003', '2022-03-05', 34000.00, 'active'),
(3, 2, 'Robert', 'Lee', 'robert.lee@gamestore.com', '312-555-3001', '2020-08-15', 54000.00, 'active'),
(3, 3, 'Jennifer', 'Taylor', 'jennifer.taylor@gamestore.com', '312-555-3002', '2021-10-20', 35500.00, 'active'),
(3, 4, 'William', 'Anderson', 'william.anderson@gamestore.com', '312-555-3003', '2022-05-10', 38000.00, 'active'),
(4, 2, 'Richard', 'Jackson', 'richard.jackson@gamestore.com', '713-555-4001', '2021-02-10', 53000.00, 'active'),
(4, 3, 'Susan', 'White', 'susan.white@gamestore.com', '713-555-4002', '2021-09-15', 35000.00, 'active'),
(4, 5, 'Thomas', 'Harris', 'thomas.harris@gamestore.com', '713-555-4003', '2020-12-01', 48000.00, 'active'),
(5, 2, 'Charles', 'Martin', 'charles.martin@gamestore.com', '305-555-5001', '2020-11-05', 54500.00, 'active'),
(5, 3, 'Jessica', 'Thompson', 'jessica.thompson@gamestore.com', '305-555-5002', '2021-12-10', 34500.00, 'active'),
(5, 3, 'Daniel', 'Moore', 'daniel.moore@gamestore.com', '305-555-5003', '2022-08-15', 34000.00, 'active'),
(6, 2, 'Nancy', 'Walker', 'nancy.walker@gamestore.com', '214-555-6001', '2021-01-20', 55500.00, 'active'),
(6, 3, 'Mark', 'Young', 'mark.young@gamestore.com', '214-555-6002', '2022-02-10', 35000.00, 'active'),
(6, 4, 'Karen', 'King', 'karen.king@gamestore.com', '214-555-6003', '2022-09-01', 37500.00, 'active'),
(7, 2, 'Paul', 'Wright', 'paul.wright@gamestore.com', '415-555-7001', '2020-09-10', 57000.00, 'active'),
(7, 3, 'Laura', 'Lopez', 'laura.lopez@gamestore.com', '415-555-7002', '2021-07-15', 36000.00, 'active'),
(7, 3, 'Kevin', 'Hill', 'kevin.hill@gamestore.com', '415-555-7003', '2022-04-20', 34000.00, 'active'),
(8, 2, 'Amanda', 'Scott', 'amanda.scott@gamestore.com', '206-555-8001', '2021-04-10', 54000.00, 'active'),
(8, 3, 'Steven', 'Green', 'steven.green@gamestore.com', '206-555-8002', '2022-01-15', 34500.00, 'active'),
(8, 4, 'Michelle', 'Adams', 'michelle.adams@gamestore.com', '206-555-8003', '2021-10-20', 38000.00, 'active'),
(9, 2, 'Brian', 'Baker', 'brian.baker@gamestore.com', '617-555-9001', '2020-12-05', 54500.00, 'active'),
(9, 3, 'Stephanie', 'Gonzalez', 'stephanie.gonzalez@gamestore.com', '617-555-9002', '2021-11-10', 35000.00, 'active'),
(9, 5, 'Jason', 'Nelson', 'jason.nelson@gamestore.com', '617-555-9003', '2020-06-15', 49000.00, 'active'),
(10, 2, 'Rebecca', 'Carter', 'rebecca.carter@gamestore.com', '303-555-0001', '2021-05-20', 53500.00, 'active'),
(10, 3, 'Eric', 'Mitchell', 'eric.mitchell@gamestore.com', '303-555-0002', '2022-03-10', 34000.00, 'active'),
(10, 4, 'Angela', 'Perez', 'angela.perez@gamestore.com', '303-555-0003', '2022-06-01', 37000.00, 'active');

-- 4. CLIENTS (100 clientes)
INSERT INTO clients (first_name, last_name, email, phone, birthdate, address, client_status) VALUES
('James', 'Smith', 'james.smith@email.com', '555-100-0001', '1990-05-15', '123 Oak St, New York, NY', 'active'),
('Mary', 'Johnson', 'mary.johnson@email.com', '555-100-0002', '1985-08-22', '456 Pine Ave, Los Angeles, CA', 'active'),
('Robert', 'Williams', 'robert.williams@email.com', '555-100-0003', '1992-03-10', '789 Elm Blvd, Chicago, IL', 'active'),
('Patricia', 'Brown', 'patricia.brown@email.com', '555-100-0004', '1988-11-05', '321 Maple Dr, Houston, TX', 'active'),
('Michael', 'Jones', 'michael.jones@email.com', '555-100-0005', '1995-07-18', '654 Cedar Ln, Miami, FL', 'active'),
('Linda', 'Garcia', 'linda.garcia@email.com', '555-100-0006', '1991-02-28', '987 Birch Way, Dallas, TX', 'active'),
('David', 'Martinez', 'david.martinez@email.com', '555-100-0007', '1987-09-12', '147 Spruce St, San Francisco, CA', 'active'),
('Barbara', 'Rodriguez', 'barbara.rodriguez@email.com', '555-100-0008', '1993-12-03', '258 Willow Ave, Seattle, WA', 'active'),
('Richard', 'Wilson', 'richard.wilson@email.com', '555-100-0009', '1986-04-25', '369 Aspen Rd, Boston, MA', 'active'),
('Susan', 'Anderson', 'susan.anderson@email.com', '555-100-0010', '1994-06-14', '741 Poplar Ct, Denver, CO', 'active'),
('Joseph', 'Thomas', 'joseph.thomas@email.com', '555-100-0011', '1989-10-08', '123 Pine St, Portland, OR', 'active'),
('Margaret', 'Taylor', 'margaret.taylor@email.com', '555-100-0012', '1996-01-19', '456 Oak Ave, Phoenix, AZ', 'active'),
('Thomas', 'Moore', 'thomas.moore@email.com', '555-100-0013', '1984-07-30', '789 Cedar Blvd, Las Vegas, NV', 'active'),
('Dorothy', 'Jackson', 'dorothy.jackson@email.com', '555-100-0014', '1991-09-21', '321 Elm Dr, San Diego, CA', 'active'),
('Charles', 'Martin', 'charles.martin@email.com', '555-100-0015', '1997-05-04', '654 Maple Ln, Austin, TX', 'active'),
('Lisa', 'Lee', 'lisa.lee@email.com', '555-100-0016', '1985-12-12', '987 Birch Way, Orlando, FL', 'active'),
('Christopher', 'White', 'chris.white@email.com', '555-100-0017', '1990-03-27', '147 Spruce Ave, Atlanta, GA', 'active'),
('Nancy', 'Harris', 'nancy.harris@email.com', '555-100-0018', '1988-08-09', '258 Willow St, Nashville, TN', 'active'),
('Daniel', 'Clark', 'daniel.clark@email.com', '555-100-0019', '1993-11-15', '369 Aspen Dr, St. Louis, MO', 'active'),
('Betty', 'Lewis', 'betty.lewis@email.com', '555-100-0020', '1986-02-01', '741 Poplar Ave, Minneapolis, MN', 'active'),
('Paul', 'Robinson', 'paul.robinson@email.com', '555-100-0021', '1994-04-18', '123 Oak Ln, Detroit, MI', 'active'),
('Sandra', 'Walker', 'sandra.walker@email.com', '555-100-0022', '1987-07-23', '456 Pine Ct, Philadelphia, PA', 'active'),
('Mark', 'Young', 'mark.young@email.com', '555-100-0023', '1995-09-05', '789 Elm Way, Baltimore, MD', 'active'),
('Ashley', 'Allen', 'ashley.allen@email.com', '555-100-0024', '1992-12-17', '321 Maple Blvd, Charlotte, NC', 'active'),
('Kenneth', 'King', 'kenneth.king@email.com', '555-100-0025', '1989-03-09', '654 Cedar St, Columbus, OH', 'active'),
('Deborah', 'Wright', 'deborah.wright@email.com', '555-100-0026', '1991-06-26', '987 Birch Dr, Indianapolis, IN', 'active'),
('Steven', 'Lopez', 'steven.lopez@email.com', '555-100-0027', '1996-10-11', '147 Spruce Ln, Milwaukee, WI', 'active'),
('Laura', 'Hill', 'laura.hill@email.com', '555-100-0028', '1985-01-30', '258 Willow Ave, Memphis, TN', 'active'),
('Kevin', 'Scott', 'kevin.scott@email.com', '555-100-0029', '1990-04-14', '369 Aspen Ct, Oklahoma City, OK', 'active'),
('Maria', 'Green', 'maria.green@email.com', '555-100-0030', '1988-08-19', '741 Poplar Way, Louisville, KY', 'active'),
('Jason', 'Adams', 'jason.adams@email.com', '555-100-0031', '1993-11-28', '123 Oak Blvd, Richmond, VA', 'active'),
('Karen', 'Baker', 'karen.baker@email.com', '555-100-0032', '1987-02-13', '456 Pine Ln, New Orleans, LA', 'active'),
('Brian', 'Gonzalez', 'brian.gonzalez@email.com', '555-100-0033', '1994-05-22', '789 Elm Dr, Birmingham, AL', 'active'),
('Donna', 'Nelson', 'donna.nelson@email.com', '555-100-0034', '1989-07-04', '321 Maple Ave, Salt Lake City, UT', 'active'),
('Eric', 'Carter', 'eric.carter@email.com', '555-100-0035', '1992-09-16', '654 Cedar Way, Albuquerque, NM', 'active'),
('Michelle', 'Mitchell', 'michelle.mitchell@email.com', '555-100-0036', '1986-12-09', '987 Birch St, Tucson, AZ', 'active'),
('Timothy', 'Perez', 'timothy.perez@email.com', '555-100-0037', '1995-03-25', '147 Spruce Ct, Fresno, CA', 'active'),
('Sarah', 'Roberts', 'sarah.roberts@email.com', '555-100-0038', '1991-10-07', '258 Willow Way, Sacramento, CA', 'active'),
('Jeffrey', 'Turner', 'jeffrey.turner@email.com', '555-100-0039', '1984-06-18', '369 Aspen Ln, Kansas City, MO', 'active'),
('Amy', 'Phillips', 'amy.phillips@email.com', '555-100-0040', '1990-08-29', '741 Poplar Blvd, Omaha, NE', 'active'),
('Ronald', 'Campbell', 'ronald.campbell@email.com', '555-100-0041', '1993-01-12', '123 Oak Ct, Miami Beach, FL', 'active'),
('Cynthia', 'Parker', 'cynthia.parker@email.com', '555-100-0042', '1988-04-24', '456 Pine Way, Santa Fe, NM', 'active'),
('Jacob', 'Evans', 'jacob.evans@email.com', '555-100-0043', '1996-07-08', '789 Elm Ct, Boise, ID', 'active'),
('Katherine', 'Edwards', 'katherine.edwards@email.com', '555-100-0044', '1985-11-19', '321 Maple Way, Spokane, WA', 'active'),
('Gary', 'Collins', 'gary.collins@email.com', '555-100-0045', '1994-02-03', '654 Cedar Blvd, Reno, NV', 'active'),
('Shirley', 'Stewart', 'shirley.stewart@email.com', '555-100-0046', '1987-09-27', '987 Birch Ct, Fort Worth, TX', 'active'),
('Frank', 'Sanchez', 'frank.sanchez@email.com', '555-100-0047', '1991-12-15', '147 Spruce Way, El Paso, TX', 'active'),
('Ruth', 'Morris', 'ruth.morris@email.com', '555-100-0048', '1986-05-08', '258 Willow Blvd, Jacksonville, FL', 'active'),
('Jose', 'Rogers', 'jose.rogers@email.com', '555-100-0049', '1992-08-20', '369 Aspen Ct, Little Rock, AR', 'active'),
('Carol', 'Reed', 'carol.reed@email.com', '555-100-0050', '1989-10-31', '741 Poplar Ln, Des Moines, IA', 'active'),
('Lawrence', 'Cook', 'lawrence.cook@email.com', '555-100-0051', '1995-03-14', '123 Oak Way, Sioux Falls, SD', 'active'),
('Judith', 'Morgan', 'judith.morgan@email.com', '555-100-0052', '1984-07-26', '456 Pine Ct, Fargo, ND', 'active'),
('Andrew', 'Bell', 'andrew.bell@email.com', '555-100-0053', '1990-11-09', '789 Elm Blvd, Billings, MT', 'active'),
('Dennis', 'Murphy', 'dennis.murphy@email.com', '555-100-0054', '1993-04-17', '321 Maple Ln, Cheyenne, WY', 'active'),
('Kathleen', 'Bailey', 'kathleen.bailey@email.com', '555-100-0055', '1988-01-28', '654 Cedar Ave, Anchorage, AK', 'active'),
('Randy', 'Rivera', 'randy.rivera@email.com', '555-100-0056', '1997-06-05', '987 Birch Ct, Honolulu, HI', 'active'),
('Christina', 'Cooper', 'christina.cooper@email.com', '555-100-0057', '1986-09-18', '147 Spruce Way, Portland, ME', 'active'),
('Ryan', 'Richardson', 'ryan.richardson@email.com', '555-100-0058', '1991-12-02', '258 Willow Ln, Manchester, NH', 'active'),
('Heather', 'Cox', 'heather.cox@email.com', '555-100-0059', '1994-03-24', '369 Aspen Blvd, Burlington, VT', 'active'),
('Billy', 'Howard', 'billy.howard@email.com', '555-100-0060', '1985-07-11', '741 Poplar Ave, Providence, RI', 'active'),
('Janet', 'Ward', 'janet.ward@email.com', '555-100-0061', '1992-10-03', '123 Oak St, Hartford, CT', 'active'),
('Adam', 'Torres', 'adam.torres@email.com', '555-100-0062', '1989-05-27', '456 Pine Ave, Wilmington, DE', 'active'),
('Virginia', 'Peterson', 'virginia.peterson@email.com', '555-100-0063', '1996-01-15', '789 Elm Blvd, Trenton, NJ', 'active'),
('Peter', 'Gray', 'peter.gray@email.com', '555-100-0064', '1987-08-08', '321 Maple Dr, Charleston, WV', 'active'),
('Alice', 'Ramirez', 'alice.ramirez@email.com', '555-100-0065', '1993-04-19', '654 Cedar Ln, Columbia, SC', 'active'),
('Tyler', 'James', 'tyler.james@email.com', '555-100-0066', '1990-12-11', '987 Birch Way, Raleigh, NC', 'active'),
('Rose', 'Watson', 'rose.watson@email.com', '555-100-0067', '1984-06-23', '147 Spruce St, Montgomery, AL', 'active'),
('Samuel', 'Brooks', 'samuel.brooks@email.com', '555-100-0068', '1995-09-07', '258 Willow Ave, Jackson, MS', 'active'),
('Martha', 'Kelly', 'martha.kelly@email.com', '555-100-0069', '1986-02-14', '369 Aspen Rd, Baton Rouge, LA', 'active'),
('Louis', 'Sanders', 'louis.sanders@email.com', '555-100-0070', '1991-07-30', '741 Poplar Ct, Tallahassee, FL', 'active'),
('Diana', 'Price', 'diana.price@email.com', '555-100-0071', '1994-10-22', '123 Oak Way, Dover, DE', 'active'),
('Gregory', 'Bennett', 'gregory.bennett@email.com', '555-100-0072', '1988-03-06', '456 Pine Blvd, Concord, NH', 'active'),
('Evelyn', 'Wood', 'evelyn.wood@email.com', '555-100-0073', '1996-05-18', '789 Elm Ct, Montpelier, VT', 'active'),
('Nicholas', 'Barnes', 'nicholas.barnes@email.com', '555-100-0074', '1985-11-29', '321 Maple Ln, Augusta, ME', 'active'),
('Gloria', 'Ross', 'gloria.ross@email.com', '555-100-0075', '1992-08-10', '654 Cedar Ave, Frankfort, KY', 'active'),
('Harold', 'Henderson', 'harold.henderson@email.com', '555-100-0076', '1989-01-02', '987 Birch St, Lincoln, NE', 'active'),
('Ann', 'Coleman', 'ann.coleman@email.com', '555-100-0077', '1993-04-25', '147 Spruce Dr, Bismarck, ND', 'active'),
('Edward', 'Jenkins', 'edward.jenkins@email.com', '555-100-0078', '1987-07-16', '258 Willow Way, Pierre, SD', 'active'),
('Joyce', 'Perry', 'joyce.perry@email.com', '555-100-0079', '1995-09-09', '369 Aspen Ct, Helena, MT', 'active'),
('Alan', 'Powell', 'alan.powell@email.com', '555-100-0080', '1984-12-21', '741 Poplar Blvd, Boise, ID', 'active'),
('Rachel', 'Long', 'rachel.long@email.com', '555-100-0081', '1991-02-13', '123 Oak Ln, Salem, OR', 'active'),
('Johnny', 'Patterson', 'johnny.patterson@email.com', '555-100-0082', '1990-06-24', '456 Pine Ave, Olympia, WA', 'active'),
('Kelly', 'Hughes', 'kelly.hughes@email.com', '555-100-0083', '1986-10-05', '789 Elm Blvd, Carson City, NV', 'active'),
('Jerry', 'Flores', 'jerry.flores@email.com', '555-100-0084', '1994-01-17', '321 Maple Dr, Phoenix, AZ', 'active'),
('Marilyn', 'Washington', 'marilyn.washington@email.com', '555-100-0085', '1988-03-28', '654 Cedar Ln, Santa Fe, NM', 'active'),
('Arthur', 'Butler', 'arthur.butler@email.com', '555-100-0086', '1992-07-08', '987 Birch Way, Oklahoma City, OK', 'active'),
('Kathryn', 'Simmons', 'kathryn.simmons@email.com', '555-100-0087', '1985-09-19', '147 Spruce St, Austin, TX', 'active'),
('Roger', 'Foster', 'roger.foster@email.com', '555-100-0088', '1996-11-30', '258 Willow Ave, Denver, CO', 'active'),
('Julie', 'Gonzales', 'julie.gonzales@email.com', '555-100-0089', '1993-05-11', '369 Aspen Rd, Salt Lake City, UT', 'active'),
('Keith', 'Bryant', 'keith.bryant@email.com', '555-100-0090', '1989-08-02', '741 Poplar Ct, Las Vegas, NV', 'active'),
('Andrea', 'Alexander', 'andrea.alexander@email.com', '555-100-0091', '1991-12-23', '123 Oak Way, Albuquerque, NM', 'active'),
('Terry', 'Russell', 'terry.russell@email.com', '555-100-0092', '1987-04-14', '456 Pine Blvd, Portland, OR', 'active'),
('Joan', 'Griffin', 'joan.griffin@email.com', '555-100-0093', '1995-10-06', '789 Elm Ct, Seattle, WA', 'active'),
('Joe', 'Diaz', 'joe.diaz@email.com', '555-100-0094', '1986-01-27', '321 Maple Ln, San Francisco, CA', 'active'),
('Doris', 'Hayes', 'doris.hayes@email.com', '555-100-0095', '1994-06-09', '654 Cedar Ave, Los Angeles, CA', 'active'),
('Sean', 'Myers', 'sean.myers@email.com', '555-100-0096', '1990-08-20', '987 Birch St, San Diego, CA', 'active'),
('Mildred', 'Ford', 'mildred.ford@email.com', '555-100-0097', '1985-11-01', '147 Spruce Dr, Chicago, IL', 'active'),
('Alexander', 'Hamilton', 'alex.hamilton@email.com', '555-100-0098', '1997-02-12', '258 Willow Way, New York, NY', 'active'),
('Frances', 'Graham', 'frances.graham@email.com', '555-100-0099', '1988-05-24', '369 Aspen Ct, Miami, FL', 'active'),
('Patrick', 'Sullivan', 'patrick.sullivan@email.com', '555-100-0100', '1992-09-03', '741 Poplar Blvd, Houston, TX', 'active');

-- 5. SUPPLIERS
INSERT INTO suppliers (supplier_name, contact_name, email, phone, address, supplier_status) VALUES
('Nintendo America', 'John Nintendo', 'supply@nintendo.com', '800-255-3700', '4600 150th Ave NE, Redmond, WA', 'active'),
('Sony Interactive', 'Maria Sony', 'supply@sony.com', '800-345-7669', '2207 Bridgepointe Pkwy, San Mateo, CA', 'active'),
('Microsoft Gaming', 'Carlos Microsoft', 'supply@microsoft.com', '800-642-7676', 'One Microsoft Way, Redmond, WA', 'active'),
('Electronic Arts', 'Sarah EA', 'supply@ea.com', '650-628-1500', '209 Redwood Shores Pkwy, Redwood City, CA', 'active'),
('Ubisoft', 'Pierre Ubisoft', 'supply@ubisoft.com', '415-547-4000', '625 3rd St, San Francisco, CA', 'active'),
('Activision', 'Robert Activision', 'supply@activision.com', '310-255-2000', '3100 Ocean Park Blvd, Santa Monica, CA', 'active'),
('Take-Two', 'David TakeTwo', 'supply@take2.com', '646-536-2842', '110 W 44th St, New York, NY', 'active'),
('Sega', 'Naomi Sega', 'supply@sega.com', '415-701-6000', '350 Rhode Island St, San Francisco, CA', 'active');

-- 6. CONSOLES
INSERT INTO consoles (console_name, manufacturer, release_year, console_status) VALUES
('Nintendo Switch', 'Nintendo', 2017, 'active'),
('PlayStation 5', 'Sony', 2020, 'active'),
('Xbox Series X', 'Microsoft', 2020, 'active'),
('PlayStation 4', 'Sony', 2013, 'active'),
('Xbox One', 'Microsoft', 2013, 'active'),
('Nintendo Switch OLED', 'Nintendo', 2021, 'active'),
('Steam Deck', 'Valve', 2022, 'active'),
('Xbox Series S', 'Microsoft', 2020, 'active'),
('PlayStation 4 Pro', 'Sony', 2016, 'active'),
('Nintendo 3DS', 'Nintendo', 2011, 'active');

-- 7. CATEGORIES
INSERT INTO categories (category_name, description, category_status) VALUES
('Action', 'Fast-paced combat games', 'active'),
('Adventure', 'Story-driven exploration', 'active'),
('RPG', 'Role-playing games', 'active'),
('Sports', 'Sports simulations', 'active'),
('Strategy', 'Tactical planning games', 'active'),
('Shooter', 'First and third person shooters', 'active'),
('Racing', 'Vehicle racing games', 'active'),
('Fighting', 'Combat fighting games', 'active'),
('Horror', 'Survival horror games', 'active'),
('Family', 'Casual family-friendly games', 'active');

-- 8. GAMES (100 juegos)
INSERT INTO games (console_id, category_id, supplier_id, game_name, developer, publisher, release_date, price, description, game_status) VALUES
-- Nintendo Switch (console_id 1) - 10 juegos
(1, 1, 1, 'The Legend of Zelda: Tears of the Kingdom', 'Nintendo', 'Nintendo', '2023-05-12', 69.99, 'Epic adventure in Hyrule', 'active'),
(1, 2, 1, 'Super Mario Odyssey', 'Nintendo', 'Nintendo', '2017-10-27', 59.99, 'Mario travels the world', 'active'),
(1, 3, 1, 'Pokemon Scarlet', 'Game Freak', 'Nintendo', '2022-11-18', 59.99, 'Open world Pokemon adventure', 'active'),
(1, 4, 1, 'Mario Kart 8 Deluxe', 'Nintendo', 'Nintendo', '2017-04-28', 59.99, 'Ultimate racing game', 'active'),
(1, 5, 1, 'Fire Emblem Engage', 'Intelligent Systems', 'Nintendo', '2023-01-20', 59.99, 'Strategic RPG battles', 'active'),
(1, 6, 1, 'Metroid Prime Remastered', 'Retro Studios', 'Nintendo', '2023-02-08', 39.99, 'First-person action adventure', 'active'),
(1, 7, 1, 'Luigi\'s Mansion 3', 'Next Level Games', 'Nintendo', '2019-10-31', 59.99, 'Ghost-hunting adventure', 'active'),
(1, 8, 1, 'Super Smash Bros Ultimate', 'Bandai Namco', 'Nintendo', '2018-12-07', 59.99, 'Fighting game crossover', 'active'),
(1, 9, 1, 'Bayonetta 3', 'PlatinumGames', 'Nintendo', '2022-10-28', 59.99, 'Action horror combat', 'active'),
(1, 10, 1, 'Animal Crossing: New Horizons', 'Nintendo', 'Nintendo', '2020-03-20', 59.99, 'Life simulation game', 'active'),
-- PlayStation 5 (console_id 2) - 10 juegos
(2, 1, 2, 'God of War Ragnarok', 'Santa Monica Studio', 'Sony', '2022-11-09', 69.99, 'Nordic mythology epic', 'active'),
(2, 2, 2, 'Horizon Forbidden West', 'Guerrilla Games', 'Sony', '2022-02-18', 69.99, 'Open world adventure', 'active'),
(2, 3, 2, 'Final Fantasy XVI', 'Square Enix', 'Square Enix', '2023-06-22', 69.99, 'Dark fantasy RPG', 'active'),
(2, 4, 2, 'Gran Turismo 7', 'Polyphony Digital', 'Sony', '2022-03-04', 69.99, 'Realistic racing','active'),
(2, 6, 2, 'Spider-Man 2', 'Insomniac Games', 'Sony', '2023-10-20', 69.99, 'Dual hero superhero action', 'active'),
(2, 9, 2, 'Resident Evil 4 Remake', 'Capcom', 'Capcom', '2023-03-24', 59.99, 'Survival horror reimagined', 'active'),
(2, 1, 2, 'Demon\'s Souls', 'Bluepoint Games', 'Sony', '2020-11-12', 59.99, 'Hardcore action RPG', 'active'),
(2, 2, 7, 'Red Dead Redemption 2', 'Rockstar Games', 'Rockstar', '2018-10-26', 49.99, 'Open world western epic', 'active'),
(2, 3, 2, 'Elden Ring', 'FromSoftware', 'Bandai Namco', '2022-02-25', 59.99, 'Open world action RPG', 'active'),
(2, 8, 2, 'Mortal Kombat 1', 'NetherRealm', 'WB Games', '2023-09-19', 69.99, 'Next-gen fighting game', 'active'),
-- Xbox Series X (console_id 3) — 10 games
(3, 6, 3, 'Halo Infinite', '343 Industries', 'Microsoft', '2021-12-08', 59.99, 'Epic sci-fi shooter', 'active'),
(3, 3, 3, 'Forza Horizon 5', 'Playground Games', 'Microsoft', '2021-11-09', 59.99, 'Open world racing', 'active'),
(3, 1, 3, 'Gears 5', 'The Coalition', 'Microsoft', '2019-09-10', 49.99, 'Cover-based shooter', 'active'),
(3, 2, 5, 'Assassin\'s Creed Mirage', 'Ubisoft Bordeaux', 'Ubisoft', '2023-10-05', 49.99, 'Return to roots stealth game', 'active'),
(3, 5, 3, 'Age of Empires IV', 'Relic Entertainment', 'Microsoft', '2021-10-28', 49.99, 'Historical RTS', 'active'),
(3, 6, 6, 'Call of Duty: Modern Warfare III', 'Sledgehammer Games', 'Activision', '2023-11-10', 69.99, 'Military shooter', 'active'),
(3, 7, 4, 'Need for Speed Unbound', 'Criterion Games', 'EA', '2022-12-02', 59.99, 'Street racing game', 'active'),
(3, 9, 3, 'The Medium', 'Bloober Team', 'Deep Silver', '2021-01-28', 39.99, 'Dual-reality horror', 'active'),
(3, 4, 4, 'EA Sports FC 24', 'EA Vancouver', 'EA', '2023-09-29', 69.99, 'Football simulation', 'active'),
(3, 8, 6, 'Tekken 8', 'Bandai Namco', 'Bandai Namco', '2024-01-26', 59.99, 'Premium fighting game', 'active'),
-- PlayStation 4 (console_id 4) — 10 games
(4, 1, 2, 'God of War', 'Santa Monica Studio', 'Sony', '2018-04-20', 39.99, 'Norse mythology action', 'active'),
(4, 2, 2, 'The Last of Us Part II', 'Naughty Dog', 'Sony', '2020-06-19', 39.99, 'Post-apocalyptic survival', 'active'),
(4, 3, 2, 'Persona 5 Royal', 'Atlus', 'Atlus', '2019-10-31', 49.99, 'Award-winning JRPG', 'active'),
(4, 6, 6, 'Call of Duty: Black Ops 4', 'Treyarch', 'Activision', '2018-10-12', 29.99, 'Tactical multiplayer shooter', 'active'),
(4, 4, 4, 'FIFA 23', 'EA Vancouver', 'EA', '2022-09-30', 39.99, 'Football simulation', 'active'),
(4, 7, 2, 'Gran Turismo Sport', 'Polyphony Digital', 'Sony', '2017-10-17', 29.99, 'Competitive racing', 'active'),
(4, 9, 2, 'Bloodborne', 'FromSoftware', 'Sony', '2015-03-24', 29.99, 'Gothic action horror RPG', 'active'),
(4, 2, 7, 'Grand Theft Auto V', 'Rockstar North', 'Rockstar', '2014-11-18', 29.99, 'Open world crime epic', 'active'),
(4, 5, 5, 'Watch Dogs 2', 'Ubisoft Montreal', 'Ubisoft', '2016-11-15', 19.99, 'Hacking open world', 'active'),
(4, 8, 2, 'Injustice 2', 'NetherRealm', 'WB Games', '2017-05-16', 24.99, 'DC superhero fighter', 'active'),
-- Xbox One (console_id 5) — 10 games
(5, 6, 3, 'Halo 5: Guardians', '343 Industries', 'Microsoft', '2015-10-27', 29.99, 'Sci-fi multiplayer shooter', 'active'),
(5, 7, 3, 'Forza Horizon 4', 'Playground Games', 'Microsoft', '2018-10-02', 39.99, 'Seasonal open world racing', 'active'),
(5, 1, 3, 'Gears of War 4', 'The Coalition', 'Microsoft', '2016-10-11', 29.99, 'Third-person shooter', 'active'),
(5, 2, 5, 'Far Cry 5', 'Ubisoft Montreal', 'Ubisoft', '2018-03-27', 29.99, 'Open world FPS', 'active'),
(5, 3, 7, 'The Witcher 3: Wild Hunt', 'CD Projekt Red', 'CD Projekt', '2015-05-19', 29.99, 'Massive open world RPG', 'active'),
(5, 4, 4, 'Madden NFL 23', 'EA Tiburon', 'EA', '2022-08-19', 39.99, 'American football simulation', 'active'),
(5, 6, 6, 'Destiny 2', 'Bungie', 'Bungie', '2017-09-06', 19.99, 'Online multiplayer FPS', 'active'),
(5, 9, 6, 'Alien Isolation', 'Creative Assembly', 'Sega', '2014-10-07', 19.99, 'Survival sci-fi horror', 'active'),
(5, 5, 5, 'Tom Clancy\'s Rainbow Six Siege', 'Ubisoft Montreal', 'Ubisoft', '2015-12-01', 19.99, 'Tactical multiplayer shooter', 'active'),
(5, 10, 4, 'Plants vs Zombies: BFN', 'PopCap', 'EA', '2019-02-25', 19.99, 'Family shooter game', 'active'),
-- Nintendo Switch OLED (console_id 6) — 10 games
(6, 3, 1, 'Xenoblade Chronicles 3', 'Monolith Soft', 'Nintendo', '2022-07-29', 59.99, 'Epic JRPG adventure', 'active'),
(6, 1, 1, 'Kirby and the Forgotten Land', 'HAL Laboratory', 'Nintendo', '2022-03-25', 59.99, '3D platformer adventure', 'active'),
(6, 2, 1, 'Splatoon 3', 'Nintendo', 'Nintendo', '2022-09-09', 59.99, 'Colorful team shooter', 'active'),
(6, 4, 8, 'Nintendo Switch Sports', 'Nintendo', 'Nintendo', '2022-04-29', 49.99, 'Motion sports collection', 'active'),
(6, 5, 1, 'Triangle Strategy', 'Square Enix', 'Nintendo', '2022-03-04', 59.99, 'Tactical RPG', 'active'),
(6, 10, 1, 'Pikmin 4', 'Nintendo', 'Nintendo', '2023-07-21', 59.99, 'Real-time strategy adventure', 'active'),
(6, 8, 1, 'Arms', 'Nintendo', 'Nintendo', '2017-06-16', 39.99, 'Motion-controlled fighter', 'active'),
(6, 7, 1, 'Fast RMX', 'Shin\'en Multimedia', 'Shin\'en', '2017-03-03', 19.99, 'Futuristic racing game', 'active'),
(6, 9, 1, 'Outlast Trinity', 'Red Barrels', 'Red Barrels', '2017-03-28', 29.99, 'Extreme survival horror', 'active'),
(6, 6, 6, 'Wolfenstein II: The New Colossus', 'MachineGames', 'Bethesda', '2017-10-27', 39.99, 'Alternate history FPS', 'active'),
-- Steam Deck (console_id 7) — 10 games
(7, 3, 7, 'Cyberpunk 2077', 'CD Projekt Red', 'CD Projekt', '2020-12-10', 59.99, 'Open world sci-fi RPG', 'active'),
(7, 1, 5, 'Hollow Knight', 'Team Cherry', 'Team Cherry', '2017-02-24', 14.99, 'Dark metroidvania', 'active'),
(7, 2, 7, 'Stardew Valley', 'ConcernedApe', 'ConcernedApe', '2016-02-26', 14.99, 'Relaxing farming RPG', 'active'),
(7, 6, 6, 'Doom Eternal', 'id Software', 'Bethesda', '2020-03-20', 39.99, 'Fast-paced demon shooter', 'active'),
(7, 5, 7, 'Into the Breach', 'Subset Games', 'Subset Games', '2018-02-27', 14.99, 'Tactical strategy puzzle', 'active'),
(7, 9, 7, 'Hades', 'Supergiant Games', 'Supergiant', '2020-09-17', 24.99, 'Roguelike action dungeon', 'active'),
(7, 7, 4, 'F1 23', 'Codemasters', 'EA', '2023-06-16', 59.99, 'Official F1 racing game', 'active'),
(7, 8, 8, 'Street Fighter 6', 'Capcom', 'Capcom', '2023-06-02', 59.99, 'Modern 2D fighter', 'active'),
(7, 10, 7, 'Terraria', 'Re-Logic', 'Re-Logic', '2011-05-16', 9.99, 'Sandbox adventure game', 'active'),
(7, 4, 4, 'Rocket League', 'Psyonix', 'Psyonix', '2015-07-07', 19.99, 'Soccer with rocket cars', 'active'),
-- Xbox Series S (console_id 8) — 10 games
(8, 6, 3, 'Halo: The Master Chief Collection', '343 Industries', 'Microsoft', '2014-11-11', 39.99, 'Six Halo games in one', 'active'),
(8, 7, 3, 'Forza Motorsport', 'Turn 10 Studios', 'Microsoft', '2023-10-10', 69.99, 'Realistic racing sim', 'active'),
(8, 1, 3, 'Gears Tactics', 'The Coalition', 'Microsoft', '2021-04-28', 39.99, 'Turn-based tactics', 'active'),
(8, 3, 7, 'The Elder Scrolls V: Skyrim', 'Bethesda', 'Bethesda', '2011-11-11', 39.99, 'Fantasy open world RPG', 'active'),
(8, 2, 5, 'Assassin\'s Creed Valhalla', 'Ubisoft Montreal', 'Ubisoft', '2020-11-10', 49.99, 'Viking open world', 'active'),
(8, 9, 7, 'Alan Wake 2', 'Remedy Entertainment', 'Epic Games', '2023-10-27', 59.99, 'Psychological horror sequel', 'active'),
(8, 5, 4, 'Command & Conquer Remastered', 'Petroglyph Games', 'EA', '2020-06-05', 19.99, 'Classic RTS remastered', 'active'),
(8, 4, 4, 'NHL 24', 'EA Vancouver', 'EA', '2023-10-06', 69.99, 'Ice hockey simulation', 'active'),
(8, 10, 3, 'Minecraft', 'Mojang', 'Microsoft', '2011-11-18', 29.99, 'Creative sandbox survival', 'active'),
(8, 8, 6, 'Mortal Kombat 11', 'NetherRealm', 'WB Games', '2019-04-23', 39.99, 'Brutal fighting game', 'active'),
-- PlayStation 4 Pro (console_id 9) — 10 games
(9, 1, 2, 'Ghost of Tsushima', 'Sucker Punch', 'Sony', '2020-07-17', 49.99, 'Samurai open world', 'active'),
(9, 2, 2, 'Uncharted 4', 'Naughty Dog', 'Sony', '2016-05-10', 29.99, 'Action adventure treasure hunt', 'active'),
(9, 3, 2, 'Horizon Zero Dawn', 'Guerrilla Games', 'Sony', '2017-02-28', 29.99, 'Post-apocalyptic RPG', 'active'),
(9, 6, 6, 'Overwatch 2', 'Blizzard', 'Blizzard', '2022-10-04', 0.00, 'Team-based hero shooter', 'active'),
(9, 4, 4, 'NBA 2K24', 'Visual Concepts', '2K Sports', '2023-09-08', 69.99, 'Basketball simulation', 'active'),
(9, 7, 2, 'WipEout Omega Collection', 'SIE Studio Liverpool', 'Sony', '2017-06-06', 29.99, 'Anti-gravity racing', 'active'),
(9, 9, 2, 'Until Dawn', 'Supermassive Games', 'Sony', '2015-08-25', 29.99, 'Interactive survival horror', 'active'),
(9, 5, 5, 'Anno 1800', 'Ubisoft Blue Byte', 'Ubisoft', '2019-04-16', 39.99, 'City-building strategy', 'active'),
(9, 8, 8, 'Tekken 7', 'Bandai Namco', 'Bandai Namco', '2015-03-18', 29.99, '3D fighting series', 'active'),
(9, 10, 2, 'LittleBigPlanet 3', 'Sumo Digital', 'Sony', '2014-11-18', 24.99, 'Creative family platformer', 'active'),
-- Nintendo 3DS (console_id 10) — 10 games
(10, 3, 1, 'Pokemon X', 'Game Freak', 'Nintendo', '2013-10-12', 39.99, 'Classic 3D Pokemon adventure', 'active'),
(10, 2, 1, 'The Legend of Zelda: A Link Between Worlds', 'Nintendo', 'Nintendo', '2013-11-22', 39.99, 'Top-down Zelda adventure', 'active'),
(10, 1, 1, 'Super Mario 3D Land', 'Nintendo', 'Nintendo', '2011-11-13', 34.99, '3D platformer adventure', 'active'),
(10, 8, 1, 'Super Smash Bros for 3DS', 'Bandai Namco', 'Nintendo', '2014-10-03', 39.99, 'Handheld fighting crossover', 'active'),
(10, 7, 1, 'Mario Kart 7', 'Nintendo', 'Nintendo', '2011-12-04', 34.99, 'Kart racing classic', 'active'),
(10, 5, 1, 'Fire Emblem Fates', 'Intelligent Systems', 'Nintendo', '2015-06-25', 39.99, 'Tactical RPG dual story', 'active'),
(10, 10, 1, 'Animal Crossing: New Leaf', 'Nintendo', 'Nintendo', '2012-11-08', 34.99, 'Life simulation on the go', 'active'),
(10, 4, 1, 'Mario Sports Superstars', 'Camelot', 'Nintendo', '2017-03-10', 29.99, 'Multi-sport collection', 'active'),
(10, 9, 1, 'Resident Evil: Revelations', 'Capcom', 'Capcom', '2012-01-26', 29.99, 'Survival horror on handheld', 'active'),
(10, 6, 1, 'Kid Icarus: Uprising', 'Project Sora', 'Nintendo', '2012-03-23', 34.99, 'Action shooter adventure', 'active');

-- 9. INVENTORY (all 100 games × 10 stablishments)
INSERT INTO inventory (game_id, stablishment_id, quantity, min_stock, last_restocked) VALUES
-- Games 1-10 (Nintendo Switch)
(1,1,15,5,'2024-01-10'),(1,2,12,5,'2024-01-08'),(1,3,18,5,'2024-01-12'),(1,4,10,5,'2024-01-05'),
(1,5,14,5,'2024-01-09'),(1,6,11,5,'2024-01-11'),(1,7,16,5,'2024-01-07'),(1,8,13,5,'2024-01-06'),
(1,9,9,5,'2024-01-04'),(1,10,17,5,'2024-01-13'),
(2,1,20,5,'2024-01-10'),(2,2,18,5,'2024-01-08'),(2,3,22,5,'2024-01-12'),(2,4,15,5,'2024-01-05'),
(2,5,19,5,'2024-01-09'),(2,6,16,5,'2024-01-11'),(2,7,21,5,'2024-01-07'),(2,8,14,5,'2024-01-06'),
(2,9,17,5,'2024-01-04'),(2,10,23,5,'2024-01-13'),
(3,1,18,5,'2024-01-10'),(3,2,15,5,'2024-01-08'),(3,3,20,5,'2024-01-12'),(3,4,12,5,'2024-01-05'),
(3,5,16,5,'2024-01-09'),(3,6,13,5,'2024-01-11'),(3,7,19,5,'2024-01-07'),(3,8,11,5,'2024-01-06'),
(3,9,14,5,'2024-01-04'),(3,10,21,5,'2024-01-13'),
(4,1,25,5,'2024-01-10'),(4,2,22,5,'2024-01-08'),(4,3,28,5,'2024-01-12'),(4,4,19,5,'2024-01-05'),
(4,5,23,5,'2024-01-09'),(4,6,20,5,'2024-01-11'),(4,7,26,5,'2024-01-07'),(4,8,17,5,'2024-01-06'),
(4,9,21,5,'2024-01-04'),(4,10,29,5,'2024-01-13'),
(5,1,8,5,'2024-01-10'),(5,2,6,5,'2024-01-08'),(5,3,10,5,'2024-01-12'),(5,4,5,5,'2024-01-05'),
(5,5,7,5,'2024-01-09'),(5,6,4,5,'2024-01-11'),(5,7,9,5,'2024-01-07'),(5,8,3,5,'2024-01-06'),
(5,9,6,5,'2024-01-04'),(5,10,11,5,'2024-01-13'),
(6,1,10,5,'2024-01-10'),(6,2,8,5,'2024-01-08'),(6,3,12,5,'2024-01-12'),(6,4,7,5,'2024-01-05'),
(6,5,9,5,'2024-01-09'),(6,6,6,5,'2024-01-11'),(6,7,11,5,'2024-01-07'),(6,8,5,5,'2024-01-06'),
(6,9,8,5,'2024-01-04'),(6,10,13,5,'2024-01-13'),
(7,1,12,5,'2024-01-10'),(7,2,10,5,'2024-01-08'),(7,3,14,5,'2024-01-12'),(7,4,8,5,'2024-01-05'),
(7,5,11,5,'2024-01-09'),(7,6,7,5,'2024-01-11'),(7,7,13,5,'2024-01-07'),(7,8,6,5,'2024-01-06'),
(7,9,9,5,'2024-01-04'),(7,10,15,5,'2024-01-13'),
(8,1,22,5,'2024-01-10'),(8,2,19,5,'2024-01-08'),(8,3,25,5,'2024-01-12'),(8,4,16,5,'2024-01-05'),
(8,5,20,5,'2024-01-09'),(8,6,17,5,'2024-01-11'),(8,7,23,5,'2024-01-07'),(8,8,14,5,'2024-01-06'),
(8,9,18,5,'2024-01-04'),(8,10,26,5,'2024-01-13'),
(9,1,7,5,'2024-01-10'),(9,2,5,5,'2024-01-08'),(9,3,9,5,'2024-01-12'),(9,4,4,5,'2024-01-05'),
(9,5,6,5,'2024-01-09'),(9,6,3,5,'2024-01-11'),(9,7,8,5,'2024-01-07'),(9,8,2,5,'2024-01-06'),
(9,9,5,5,'2024-01-04'),(9,10,10,5,'2024-01-13'),
(10,1,20,5,'2024-01-10'),(10,2,17,5,'2024-01-08'),(10,3,23,5,'2024-01-12'),(10,4,14,5,'2024-01-05'),
(10,5,18,5,'2024-01-09'),(10,6,15,5,'2024-01-11'),(10,7,21,5,'2024-01-07'),(10,8,12,5,'2024-01-06'),
(10,9,16,5,'2024-01-04'),(10,10,24,5,'2024-01-13'),
-- Games 11-20 (Playstation 5)
(11,1,18,5,'2024-01-10'),(11,2,15,5,'2024-01-08'),(11,3,20,5,'2024-01-12'),(11,4,13,5,'2024-01-05'),
(11,5,17,5,'2024-01-09'),(11,6,14,5,'2024-01-11'),(11,7,19,5,'2024-01-07'),(11,8,11,5,'2024-01-06'),
(11,9,15,5,'2024-01-04'),(11,10,22,5,'2024-01-13'),
(12,1,14,5,'2024-01-10'),(12,2,11,5,'2024-01-08'),(12,3,16,5,'2024-01-12'),(12,4,9,5,'2024-01-05'),
(12,5,13,5,'2024-01-09'),(12,6,10,5,'2024-01-11'),(12,7,15,5,'2024-01-07'),(12,8,7,5,'2024-01-06'),
(12,9,11,5,'2024-01-04'),(12,10,18,5,'2024-01-13'),
(13,1,12,5,'2024-01-10'),(13,2,9,5,'2024-01-08'),(13,3,14,5,'2024-01-12'),(13,4,7,5,'2024-01-05'),
(13,5,11,5,'2024-01-09'),(13,6,8,5,'2024-01-11'),(13,7,13,5,'2024-01-07'),(13,8,5,5,'2024-01-06'),
(13,9,9,5,'2024-01-04'),(13,10,16,5,'2024-01-13'),
(14,1,10,5,'2024-01-10'),(14,2,8,5,'2024-01-08'),(14,3,12,5,'2024-01-12'),(14,4,6,5,'2024-01-05'),
(14,5,9,5,'2024-01-09'),(14,6,7,5,'2024-01-11'),(14,7,11,5,'2024-01-07'),(14,8,5,5,'2024-01-06'),
(14,9,8,5,'2024-01-04'),(14,10,13,5,'2024-01-13'),
(15,1,16,5,'2024-01-10'),(15,2,13,5,'2024-01-08'),(15,3,18,5,'2024-01-12'),(15,4,11,5,'2024-01-05'),
(15,5,15,5,'2024-01-09'),(15,6,12,5,'2024-01-11'),(15,7,17,5,'2024-01-07'),(15,8,9,5,'2024-01-06'),
(15,9,13,5,'2024-01-04'),(15,10,20,5,'2024-01-13'),
(16,1,14,5,'2024-01-10'),(16,2,11,5,'2024-01-08'),(16,3,16,5,'2024-01-12'),(16,4,9,5,'2024-01-05'),
(16,5,13,5,'2024-01-09'),(16,6,10,5,'2024-01-11'),(16,7,15,5,'2024-01-07'),(16,8,7,5,'2024-01-06'),
(16,9,11,5,'2024-01-04'),(16,10,18,5,'2024-01-13'),
(17,1,8,5,'2024-01-10'),(17,2,6,5,'2024-01-08'),(17,3,10,5,'2024-01-12'),(17,4,5,5,'2024-01-05'),
(17,5,7,5,'2024-01-09'),(17,6,4,5,'2024-01-11'),(17,7,9,5,'2024-01-07'),(17,8,3,5,'2024-01-06'),
(17,9,6,5,'2024-01-04'),(17,10,11,5,'2024-01-13'),
(18,1,12,5,'2024-01-10'),(18,2,10,5,'2024-01-08'),(18,3,14,5,'2024-01-12'),(18,4,8,5,'2024-01-05'),
(18,5,11,5,'2024-01-09'),(18,6,9,5,'2024-01-11'),(18,7,13,5,'2024-01-07'),(18,8,6,5,'2024-01-06'),
(18,9,10,5,'2024-01-04'),(18,10,15,5,'2024-01-13'),
(19,1,15,5,'2024-01-10'),(19,2,12,5,'2024-01-08'),(19,3,17,5,'2024-01-12'),(19,4,10,5,'2024-01-05'),
(19,5,14,5,'2024-01-09'),(19,6,11,5,'2024-01-11'),(19,7,16,5,'2024-01-07'),(19,8,8,5,'2024-01-06'),
(19,9,12,5,'2024-01-04'),(19,10,19,5,'2024-01-13'),
(20,1,11,5,'2024-01-10'),(20,2,9,5,'2024-01-08'),(20,3,13,5,'2024-01-12'),(20,4,7,5,'2024-01-05'),
(20,5,10,5,'2024-01-09'),(20,6,8,5,'2024-01-11'),(20,7,12,5,'2024-01-07'),(20,8,5,5,'2024-01-06'),
(20,9,9,5,'2024-01-04'),(20,10,14,5,'2024-01-13'),
-- Games 21-30 (Xbox Series X)
(21,1,14,5,'2024-01-10'),(21,2,11,5,'2024-01-08'),(21,3,16,5,'2024-01-12'),(21,4,9,5,'2024-01-05'),
(21,5,13,5,'2024-01-09'),(21,6,10,5,'2024-01-11'),(21,7,15,5,'2024-01-07'),(21,8,7,5,'2024-01-06'),
(21,9,11,5,'2024-01-04'),(21,10,18,5,'2024-01-13'),
(22,1,12,5,'2024-01-10'),(22,2,10,5,'2024-01-08'),(22,3,14,5,'2024-01-12'),(22,4,8,5,'2024-01-05'),
(22,5,11,5,'2024-01-09'),(22,6,9,5,'2024-01-11'),(22,7,13,5,'2024-01-07'),(22,8,6,5,'2024-01-06'),
(22,9,10,5,'2024-01-04'),(22,10,15,5,'2024-01-13'),
(23,1,8,5,'2024-01-10'),(23,2,6,5,'2024-01-08'),(23,3,10,5,'2024-01-12'),(23,4,5,5,'2024-01-05'),
(23,5,7,5,'2024-01-09'),(23,6,4,5,'2024-01-11'),(23,7,9,5,'2024-01-07'),(23,8,3,5,'2024-01-06'),
(23,9,6,5,'2024-01-04'),(23,10,11,5,'2024-01-13'),
(24,1,9,5,'2024-01-10'),(24,2,7,5,'2024-01-08'),(24,3,11,5,'2024-01-12'),(24,4,5,5,'2024-01-05'),
(24,5,8,5,'2024-01-09'),(24,6,6,5,'2024-01-11'),(24,7,10,5,'2024-01-07'),(24,8,4,5,'2024-01-06'),
(24,9,7,5,'2024-01-04'),(24,10,12,5,'2024-01-13'),
(25,1,7,5,'2024-01-10'),(25,2,5,5,'2024-01-08'),(25,3,9,5,'2024-01-12'),(25,4,4,5,'2024-01-05'),
(25,5,6,5,'2024-01-09'),(25,6,3,5,'2024-01-11'),(25,7,8,5,'2024-01-07'),(25,8,2,5,'2024-01-06'),
(25,9,5,5,'2024-01-04'),(25,10,10,5,'2024-01-13'),
(26,1,13,5,'2024-01-10'),(26,2,11,5,'2024-01-08'),(26,3,15,5,'2024-01-12'),(26,4,9,5,'2024-01-05'),
(26,5,12,5,'2024-01-09'),(26,6,10,5,'2024-01-11'),(26,7,14,5,'2024-01-07'),(26,8,7,5,'2024-01-06'),
(26,9,11,5,'2024-01-04'),(26,10,16,5,'2024-01-13'),
(27,1,10,5,'2024-01-10'),(27,2,8,5,'2024-01-08'),(27,3,12,5,'2024-01-12'),(27,4,6,5,'2024-01-05'),
(27,5,9,5,'2024-01-09'),(27,6,7,5,'2024-01-11'),(27,7,11,5,'2024-01-07'),(27,8,5,5,'2024-01-06'),
(27,9,8,5,'2024-01-04'),(27,10,13,5,'2024-01-13'),
(28,1,6,5,'2024-01-10'),(28,2,4,5,'2024-01-08'),(28,3,8,5,'2024-01-12'),(28,4,3,5,'2024-01-05'),
(28,5,5,5,'2024-01-09'),(28,6,2,5,'2024-01-11'),(28,7,7,5,'2024-01-07'),(28,8,1,5,'2024-01-06'),
(28,9,4,5,'2024-01-04'),(28,10,9,5,'2024-01-13'),
(29,1,14,5,'2024-01-10'),(29,2,12,5,'2024-01-08'),(29,3,16,5,'2024-01-12'),(29,4,10,5,'2024-01-05'),
(29,5,13,5,'2024-01-09'),(29,6,11,5,'2024-01-11'),(29,7,15,5,'2024-01-07'),(29,8,8,5,'2024-01-06'),
(29,9,12,5,'2024-01-04'),(29,10,17,5,'2024-01-13'),
(30,1,11,5,'2024-01-10'),(30,2,9,5,'2024-01-08'),(30,3,13,5,'2024-01-12'),(30,4,7,5,'2024-01-05'),
(30,5,10,5,'2024-01-09'),(30,6,8,5,'2024-01-11'),(30,7,12,5,'2024-01-07'),(30,8,5,5,'2024-01-06'),
(30,9,9,5,'2024-01-04'),(30,10,14,5,'2024-01-13'),
-- Games 31-40 (PS4)
(31,1,10,5,'2024-01-10'),(31,2,8,5,'2024-01-08'),(31,3,12,5,'2024-01-12'),(31,4,6,5,'2024-01-05'),
(31,5,9,5,'2024-01-09'),(31,6,7,5,'2024-01-11'),(31,7,11,5,'2024-01-07'),(31,8,5,5,'2024-01-06'),
(31,9,8,5,'2024-01-04'),(31,10,13,5,'2024-01-13'),
(32,1,12,5,'2024-01-10'),(32,2,10,5,'2024-01-08'),(32,3,14,5,'2024-01-12'),(32,4,8,5,'2024-01-05'),
(32,5,11,5,'2024-01-09'),(32,6,9,5,'2024-01-11'),(32,7,13,5,'2024-01-07'),(32,8,6,5,'2024-01-06'),
(32,9,10,5,'2024-01-04'),(32,10,15,5,'2024-01-13'),
(33,1,9,5,'2024-01-10'),(33,2,7,5,'2024-01-08'),(33,3,11,5,'2024-01-12'),(33,4,5,5,'2024-01-05'),
(33,5,8,5,'2024-01-09'),(33,6,6,5,'2024-01-11'),(33,7,10,5,'2024-01-07'),(33,8,4,5,'2024-01-06'),
(33,9,7,5,'2024-01-04'),(33,10,12,5,'2024-01-13'),
(34,1,15,5,'2024-01-10'),(34,2,13,5,'2024-01-08'),(34,3,17,5,'2024-01-12'),(34,4,11,5,'2024-01-05'),
(34,5,14,5,'2024-01-09'),(34,6,12,5,'2024-01-11'),(34,7,16,5,'2024-01-07'),(34,8,9,5,'2024-01-06'),
(34,9,13,5,'2024-01-04'),(34,10,18,5,'2024-01-13'),
(35,1,13,5,'2024-01-10'),(35,2,11,5,'2024-01-08'),(35,3,15,5,'2024-01-12'),(35,4,9,5,'2024-01-05'),
(35,5,12,5,'2024-01-09'),(35,6,10,5,'2024-01-11'),(35,7,14,5,'2024-01-07'),(35,8,7,5,'2024-01-06'),
(35,9,11,5,'2024-01-04'),(35,10,16,5,'2024-01-13'),
(36,1,8,5,'2024-01-10'),(36,2,6,5,'2024-01-08'),(36,3,10,5,'2024-01-12'),(36,4,4,5,'2024-01-05'),
(36,5,7,5,'2024-01-09'),(36,6,5,5,'2024-01-11'),(36,7,9,5,'2024-01-07'),(36,8,3,5,'2024-01-06'),
(36,9,6,5,'2024-01-04'),(36,10,11,5,'2024-01-13'),
(37,1,11,5,'2024-01-10'),(37,2,9,5,'2024-01-08'),(37,3,13,5,'2024-01-12'),(37,4,7,5,'2024-01-05'),
(37,5,10,5,'2024-01-09'),(37,6,8,5,'2024-01-11'),(37,7,12,5,'2024-01-07'),(37,8,5,5,'2024-01-06'),
(37,9,9,5,'2024-01-04'),(37,10,14,5,'2024-01-13'),
(38,1,16,5,'2024-01-10'),(38,2,14,5,'2024-01-08'),(38,3,18,5,'2024-01-12'),(38,4,12,5,'2024-01-05'),
(38,5,15,5,'2024-01-09'),(38,6,13,5,'2024-01-11'),(38,7,17,5,'2024-01-07'),(38,8,10,5,'2024-01-06'),
(38,9,14,5,'2024-01-04'),(38,10,19,5,'2024-01-13'),
(39,1,7,5,'2024-01-10'),(39,2,5,5,'2024-01-08'),(39,3,9,5,'2024-01-12'),(39,4,3,5,'2024-01-05'),
(39,5,6,5,'2024-01-09'),(39,6,4,5,'2024-01-11'),(39,7,8,5,'2024-01-07'),(39,8,2,5,'2024-01-06'),
(39,9,5,5,'2024-01-04'),(39,10,10,5,'2024-01-13'),
(40,1,9,5,'2024-01-10'),(40,2,7,5,'2024-01-08'),(40,3,11,5,'2024-01-12'),(40,4,5,5,'2024-01-05'),
(40,5,8,5,'2024-01-09'),(40,6,6,5,'2024-01-11'),(40,7,10,5,'2024-01-07'),(40,8,4,5,'2024-01-06'),
(40,9,7,5,'2024-01-04'),(40,10,12,5,'2024-01-13'),
-- Games 41-50 (Xbox One)
(41,1,8,5,'2024-01-10'),(41,2,6,5,'2024-01-08'),(41,3,10,5,'2024-01-12'),(41,4,4,5,'2024-01-05'),
(41,5,7,5,'2024-01-09'),(41,6,5,5,'2024-01-11'),(41,7,9,5,'2024-01-07'),(41,8,3,5,'2024-01-06'),
(41,9,6,5,'2024-01-04'),(41,10,11,5,'2024-01-13'),
(42,1,10,5,'2024-01-10'),(42,2,8,5,'2024-01-08'),(42,3,12,5,'2024-01-12'),(42,4,6,5,'2024-01-05'),
(42,5,9,5,'2024-01-09'),(42,6,7,5,'2024-01-11'),(42,7,11,5,'2024-01-07'),(42,8,5,5,'2024-01-06'),
(42,9,8,5,'2024-01-04'),(42,10,13,5,'2024-01-13'),
(43,1,7,5,'2024-01-10'),(43,2,5,5,'2024-01-08'),(43,3,9,5,'2024-01-12'),(43,4,3,5,'2024-01-05'),
(43,5,6,5,'2024-01-09'),(43,6,4,5,'2024-01-11'),(43,7,8,5,'2024-01-07'),(43,8,2,5,'2024-01-06'),
(43,9,5,5,'2024-01-04'),(43,10,10,5,'2024-01-13'),
(44,1,9,5,'2024-01-10'),(44,2,7,5,'2024-01-08'),(44,3,11,5,'2024-01-12'),(44,4,5,5,'2024-01-05'),
(44,5,8,5,'2024-01-09'),(44,6,6,5,'2024-01-11'),(44,7,10,5,'2024-01-07'),(44,8,4,5,'2024-01-06'),
(44,9,7,5,'2024-01-04'),(44,10,12,5,'2024-01-13'),
(45,1,12,5,'2024-01-10'),(45,2,10,5,'2024-01-08'),(45,3,14,5,'2024-01-12'),(45,4,8,5,'2024-01-05'),
(45,5,11,5,'2024-01-09'),(45,6,9,5,'2024-01-11'),(45,7,13,5,'2024-01-07'),(45,8,6,5,'2024-01-06'),
(45,9,10,5,'2024-01-04'),(45,10,15,5,'2024-01-13'),
(46,1,11,5,'2024-01-10'),(46,2,9,5,'2024-01-08'),(46,3,13,5,'2024-01-12'),(46,4,7,5,'2024-01-05'),
(46,5,10,5,'2024-01-09'),(46,6,8,5,'2024-01-11'),(46,7,12,5,'2024-01-07'),(46,8,5,5,'2024-01-06'),
(46,9,9,5,'2024-01-04'),(46,10,14,5,'2024-01-13'),
(47,1,6,5,'2024-01-10'),(47,2,4,5,'2024-01-08'),(47,3,8,5,'2024-01-12'),(47,4,3,5,'2024-01-05'),
(47,5,5,5,'2024-01-09'),(47,6,2,5,'2024-01-11'),(47,7,7,5,'2024-01-07'),(47,8,1,5,'2024-01-06'),
(47,9,4,5,'2024-01-04'),(47,10,9,5,'2024-01-13'),
(48,1,5,5,'2024-01-10'),(48,2,3,5,'2024-01-08'),(48,3,7,5,'2024-01-12'),(48,4,2,5,'2024-01-05'),
(48,5,4,5,'2024-01-09'),(48,6,1,5,'2024-01-11'),(48,7,6,5,'2024-01-07'),(48,8,1,5,'2024-01-06'),
(48,9,3,5,'2024-01-04'),(48,10,8,5,'2024-01-13'),
(49,1,7,5,'2024-01-10'),(49,2,5,5,'2024-01-08'),(49,3,9,5,'2024-01-12'),(49,4,3,5,'2024-01-05'),
(49,5,6,5,'2024-01-09'),(49,6,4,5,'2024-01-11'),(49,7,8,5,'2024-01-07'),(49,8,2,5,'2024-01-06'),
(49,9,5,5,'2024-01-04'),(49,10,10,5,'2024-01-13'),
(50,1,6,5,'2024-01-10'),(50,2,4,5,'2024-01-08'),(50,3,8,5,'2024-01-12'),(50,4,2,5,'2024-01-05'),
(50,5,5,5,'2024-01-09'),(50,6,3,5,'2024-01-11'),(50,7,7,5,'2024-01-07'),(50,8,1,5,'2024-01-06'),
(50,9,4,5,'2024-01-04'),(50,10,9,5,'2024-01-13'),
-- Games 51-60 (Switch OLED)
(51,1,9,5,'2024-01-10'),(51,2,7,5,'2024-01-08'),(51,3,11,5,'2024-01-12'),(51,4,5,5,'2024-01-05'),
(51,5,8,5,'2024-01-09'),(51,6,6,5,'2024-01-11'),(51,7,10,5,'2024-01-07'),(51,8,4,5,'2024-01-06'),
(51,9,7,5,'2024-01-04'),(51,10,12,5,'2024-01-13'),
(52,1,12,5,'2024-01-10'),(52,2,10,5,'2024-01-08'),(52,3,14,5,'2024-01-12'),(52,4,8,5,'2024-01-05'),
(52,5,11,5,'2024-01-09'),(52,6,9,5,'2024-01-11'),(52,7,13,5,'2024-01-07'),(52,8,6,5,'2024-01-06'),
(52,9,10,5,'2024-01-04'),(52,10,15,5,'2024-01-13'),
(53,1,14,5,'2024-01-10'),(53,2,12,5,'2024-01-08'),(53,3,16,5,'2024-01-12'),(53,4,10,5,'2024-01-05'),
(53,5,13,5,'2024-01-09'),(53,6,11,5,'2024-01-11'),(53,7,15,5,'2024-01-07'),(53,8,8,5,'2024-01-06'),
(53,9,12,5,'2024-01-04'),(53,10,17,5,'2024-01-13'),
(54,1,10,5,'2024-01-10'),(54,2,8,5,'2024-01-08'),(54,3,12,5,'2024-01-12'),(54,4,6,5,'2024-01-05'),
(54,5,9,5,'2024-01-09'),(54,6,7,5,'2024-01-11'),(54,7,11,5,'2024-01-07'),(54,8,5,5,'2024-01-06'),
(54,9,8,5,'2024-01-04'),(54,10,13,5,'2024-01-13'),
(55,1,7,5,'2024-01-10'),(55,2,5,5,'2024-01-08'),(55,3,9,5,'2024-01-12'),(55,4,3,5,'2024-01-05'),
(55,5,6,5,'2024-01-09'),(55,6,4,5,'2024-01-11'),(55,7,8,5,'2024-01-07'),(55,8,2,5,'2024-01-06'),
(55,9,5,5,'2024-01-04'),(55,10,10,5,'2024-01-13'),
(56,1,11,5,'2024-01-10'),(56,2,9,5,'2024-01-08'),(56,3,13,5,'2024-01-12'),(56,4,7,5,'2024-01-05'),
(56,5,10,5,'2024-01-09'),(56,6,8,5,'2024-01-11'),(56,7,12,5,'2024-01-07'),(56,8,5,5,'2024-01-06'),
(56,9,9,5,'2024-01-04'),(56,10,14,5,'2024-01-13'),
(57,1,6,5,'2024-01-10'),(57,2,4,5,'2024-01-08'),(57,3,8,5,'2024-01-12'),(57,4,2,5,'2024-01-05'),
(57,5,5,5,'2024-01-09'),(57,6,3,5,'2024-01-11'),(57,7,7,5,'2024-01-07'),(57,8,1,5,'2024-01-06'),
(57,9,4,5,'2024-01-04'),(57,10,9,5,'2024-01-13'),
(58,1,5,5,'2024-01-10'),(58,2,3,5,'2024-01-08'),(58,3,7,5,'2024-01-12'),(58,4,2,5,'2024-01-05'),
(58,5,4,5,'2024-01-09'),(58,6,2,5,'2024-01-11'),(58,7,6,5,'2024-01-07'),(58,8,1,5,'2024-01-06'),
(58,9,3,5,'2024-01-04'),(58,10,8,5,'2024-01-13'),
(59,1,7,5,'2024-01-10'),(59,2,5,5,'2024-01-08'),(59,3,9,5,'2024-01-12'),(59,4,3,5,'2024-01-05'),
(59,5,6,5,'2024-01-09'),(59,6,4,5,'2024-01-11'),(59,7,8,5,'2024-01-07'),(59,8,2,5,'2024-01-06'),
(59,9,5,5,'2024-01-04'),(59,10,10,5,'2024-01-13'),
(60,1,8,5,'2024-01-10'),(60,2,6,5,'2024-01-08'),(60,3,10,5,'2024-01-12'),(60,4,4,5,'2024-01-05'),
(60,5,7,5,'2024-01-09'),(60,6,5,5,'2024-01-11'),(60,7,9,5,'2024-01-07'),(60,8,3,5,'2024-01-06'),
(60,9,6,5,'2024-01-04'),(60,10,11,5,'2024-01-13'),
-- Games 61-70 (Steam Deck)
(61,1,10,5,'2024-01-10'),(61,2,8,5,'2024-01-08'),(61,3,12,5,'2024-01-12'),(61,4,6,5,'2024-01-05'),
(61,5,9,5,'2024-01-09'),(61,6,7,5,'2024-01-11'),(61,7,11,5,'2024-01-07'),(61,8,5,5,'2024-01-06'),
(61,9,8,5,'2024-01-04'),(61,10,13,5,'2024-01-13'),
(62,1,8,5,'2024-01-10'),(62,2,6,5,'2024-01-08'),(62,3,10,5,'2024-01-12'),(62,4,4,5,'2024-01-05'),
(62,5,7,5,'2024-01-09'),(62,6,5,5,'2024-01-11'),(62,7,9,5,'2024-01-07'),(62,8,3,5,'2024-01-06'),
(62,9,6,5,'2024-01-04'),(62,10,11,5,'2024-01-13'),
(63,1,9,5,'2024-01-10'),(63,2,7,5,'2024-01-08'),(63,3,11,5,'2024-01-12'),(63,4,5,5,'2024-01-05'),
(63,5,8,5,'2024-01-09'),(63,6,6,5,'2024-01-11'),(63,7,10,5,'2024-01-07'),(63,8,4,5,'2024-01-06'),
(63,9,7,5,'2024-01-04'),(63,10,12,5,'2024-01-13'),
(64,1,11,5,'2024-01-10'),(64,2,9,5,'2024-01-08'),(64,3,13,5,'2024-01-12'),(64,4,7,5,'2024-01-05'),
(64,5,10,5,'2024-01-09'),(64,6,8,5,'2024-01-11'),(64,7,12,5,'2024-01-07'),(64,8,5,5,'2024-01-06'),
(64,9,9,5,'2024-01-04'),(64,10,14,5,'2024-01-13'),
(65,1,6,5,'2024-01-10'),(65,2,4,5,'2024-01-08'),(65,3,8,5,'2024-01-12'),(65,4,2,5,'2024-01-05'),
(65,5,5,5,'2024-01-09'),(65,6,3,5,'2024-01-11'),(65,7,7,5,'2024-01-07'),(65,8,1,5,'2024-01-06'),
(65,9,4,5,'2024-01-04'),(65,10,9,5,'2024-01-13'),
(66,1,12,5,'2024-01-10'),(66,2,10,5,'2024-01-08'),(66,3,14,5,'2024-01-12'),(66,4,8,5,'2024-01-05'),
(66,5,11,5,'2024-01-09'),(66,6,9,5,'2024-01-11'),(66,7,13,5,'2024-01-07'),(66,8,6,5,'2024-01-06'),
(66,9,10,5,'2024-01-04'),(66,10,15,5,'2024-01-13'),
(67,1,9,5,'2024-01-10'),(67,2,7,5,'2024-01-08'),(67,3,11,5,'2024-01-12'),(67,4,5,5,'2024-01-05'),
(67,5,8,5,'2024-01-09'),(67,6,6,5,'2024-01-11'),(67,7,10,5,'2024-01-07'),(67,8,4,5,'2024-01-06'),
(67,9,7,5,'2024-01-04'),(67,10,12,5,'2024-01-13'),
(68,1,11,5,'2024-01-10'),(68,2,9,5,'2024-01-08'),(68,3,13,5,'2024-01-12'),(68,4,7,5,'2024-01-05'),
(68,5,10,5,'2024-01-09'),(68,6,8,5,'2024-01-11'),(68,7,12,5,'2024-01-07'),(68,8,5,5,'2024-01-06'),
(68,9,9,5,'2024-01-04'),(68,10,14,5,'2024-01-13'),
(69,1,7,5,'2024-01-10'),(69,2,5,5,'2024-01-08'),(69,3,9,5,'2024-01-12'),(69,4,3,5,'2024-01-05'),
(69,5,6,5,'2024-01-09'),(69,6,4,5,'2024-01-11'),(69,7,8,5,'2024-01-07'),(69,8,2,5,'2024-01-06'),
(69,9,5,5,'2024-01-04'),(69,10,10,5,'2024-01-13'),
(70,1,8,5,'2024-01-10'),(70,2,6,5,'2024-01-08'),(70,3,10,5,'2024-01-12'),(70,4,4,5,'2024-01-05'),
(70,5,7,5,'2024-01-09'),(70,6,5,5,'2024-01-11'),(70,7,9,5,'2024-01-07'),(70,8,3,5,'2024-01-06'),
(70,9,6,5,'2024-01-04'),(70,10,11,5,'2024-01-13'),
-- Games 71-80 (Xbox Series S)
(71,1,9,5,'2024-01-10'),(71,2,7,5,'2024-01-08'),(71,3,11,5,'2024-01-12'),(71,4,5,5,'2024-01-05'),
(71,5,8,5,'2024-01-09'),(71,6,6,5,'2024-01-11'),(71,7,10,5,'2024-01-07'),(71,8,4,5,'2024-01-06'),
(71,9,7,5,'2024-01-04'),(71,10,12,5,'2024-01-13'),
(72,1,11,5,'2024-01-10'),(72,2,9,5,'2024-01-08'),(72,3,13,5,'2024-01-12'),(72,4,7,5,'2024-01-05'),
(72,5,10,5,'2024-01-09'),(72,6,8,5,'2024-01-11'),(72,7,12,5,'2024-01-07'),(72,8,5,5,'2024-01-06'),
(72,9,9,5,'2024-01-04'),(72,10,14,5,'2024-01-13'),
(73,1,7,5,'2024-01-10'),(73,2,5,5,'2024-01-08'),(73,3,9,5,'2024-01-12'),(73,4,3,5,'2024-01-05'),
(73,5,6,5,'2024-01-09'),(73,6,4,5,'2024-01-11'),(73,7,8,5,'2024-01-07'),(73,8,2,5,'2024-01-06'),
(73,9,5,5,'2024-01-04'),(73,10,10,5,'2024-01-13'),
(74,1,10,5,'2024-01-10'),(74,2,8,5,'2024-01-08'),(74,3,12,5,'2024-01-12'),(74,4,6,5,'2024-01-05'),
(74,5,9,5,'2024-01-09'),(74,6,7,5,'2024-01-11'),(74,7,11,5,'2024-01-07'),(74,8,5,5,'2024-01-06'),
(74,9,8,5,'2024-01-04'),(74,10,13,5,'2024-01-13'),
(75,1,8,5,'2024-01-10'),(75,2,6,5,'2024-01-08'),(75,3,10,5,'2024-01-12'),(75,4,4,5,'2024-01-05'),
(75,5,7,5,'2024-01-09'),(75,6,5,5,'2024-01-11'),(75,7,9,5,'2024-01-07'),(75,8,3,5,'2024-01-06'),
(75,9,6,5,'2024-01-04'),(75,10,11,5,'2024-01-13'),
(76,1,12,5,'2024-01-10'),(76,2,10,5,'2024-01-08'),(76,3,14,5,'2024-01-12'),(76,4,8,5,'2024-01-05'),
(76,5,11,5,'2024-01-09'),(76,6,9,5,'2024-01-11'),(76,7,13,5,'2024-01-07'),(76,8,6,5,'2024-01-06'),
(76,9,10,5,'2024-01-04'),(76,10,15,5,'2024-01-13'),
(77,1,6,5,'2024-01-10'),(77,2,4,5,'2024-01-08'),(77,3,8,5,'2024-01-12'),(77,4,2,5,'2024-01-05'),
(77,5,5,5,'2024-01-09'),(77,6,3,5,'2024-01-11'),(77,7,7,5,'2024-01-07'),(77,8,1,5,'2024-01-06'),
(77,9,4,5,'2024-01-04'),(77,10,9,5,'2024-01-13'),
(78,1,13,5,'2024-01-10'),(78,2,11,5,'2024-01-08'),(78,3,15,5,'2024-01-12'),(78,4,9,5,'2024-01-05'),
(78,5,12,5,'2024-01-09'),(78,6,10,5,'2024-01-11'),(78,7,14,5,'2024-01-07'),(78,8,7,5,'2024-01-06'),
(78,9,11,5,'2024-01-04'),(78,10,16,5,'2024-01-13'),
(79,1,15,5,'2024-01-10'),(79,2,13,5,'2024-01-08'),(79,3,17,5,'2024-01-12'),(79,4,11,5,'2024-01-05'),
(79,5,14,5,'2024-01-09'),(79,6,12,5,'2024-01-11'),(79,7,16,5,'2024-01-07'),(79,8,9,5,'2024-01-06'),
(79,9,13,5,'2024-01-04'),(79,10,18,5,'2024-01-13'),
(80,1,9,5,'2024-01-10'),(80,2,7,5,'2024-01-08'),(80,3,11,5,'2024-01-12'),(80,4,5,5,'2024-01-05'),
(80,5,8,5,'2024-01-09'),(80,6,6,5,'2024-01-11'),(80,7,10,5,'2024-01-07'),(80,8,4,5,'2024-01-06'),
(80,9,7,5,'2024-01-04'),(80,10,12,5,'2024-01-13'),
-- Games 81-90 (PS4 Pro)
(81,1,12,5,'2024-01-10'),(81,2,10,5,'2024-01-08'),(81,3,14,5,'2024-01-12'),(81,4,8,5,'2024-01-05'),
(81,5,11,5,'2024-01-09'),(81,6,9,5,'2024-01-11'),(81,7,13,5,'2024-01-07'),(81,8,6,5,'2024-01-06'),
(81,9,10,5,'2024-01-04'),(81,10,15,5,'2024-01-13'),
(82,1,10,5,'2024-01-10'),(82,2,8,5,'2024-01-08'),(82,3,12,5,'2024-01-12'),(82,4,6,5,'2024-01-05'),
(82,5,9,5,'2024-01-09'),(82,6,7,5,'2024-01-11'),(82,7,11,5,'2024-01-07'),(82,8,5,5,'2024-01-06'),
(82,9,8,5,'2024-01-04'),(82,10,13,5,'2024-01-13'),
(83,1,11,5,'2024-01-10'),(83,2,9,5,'2024-01-08'),(83,3,13,5,'2024-01-12'),(83,4,7,5,'2024-01-05'),
(83,5,10,5,'2024-01-09'),(83,6,8,5,'2024-01-11'),(83,7,12,5,'2024-01-07'),(83,8,5,5,'2024-01-06'),
(83,9,9,5,'2024-01-04'),(83,10,14,5,'2024-01-13'),
(84,1,5,5,'2024-01-10'),(84,2,3,5,'2024-01-08'),(84,3,7,5,'2024-01-12'),(84,4,1,5,'2024-01-05'),
(84,5,4,5,'2024-01-09'),(84,6,2,5,'2024-01-11'),(84,7,6,5,'2024-01-07'),(84,8,1,5,'2024-01-06'),
(84,9,3,5,'2024-01-04'),(84,10,8,5,'2024-01-13'),
(85,1,14,5,'2024-01-10'),(85,2,12,5,'2024-01-08'),(85,3,16,5,'2024-01-12'),(85,4,10,5,'2024-01-05'),
(85,5,13,5,'2024-01-09'),(85,6,11,5,'2024-01-11'),(85,7,15,5,'2024-01-07'),(85,8,8,5,'2024-01-06'),
(85,9,12,5,'2024-01-04'),(85,10,17,5,'2024-01-13'),
(86,1,7,5,'2024-01-10'),(86,2,5,5,'2024-01-08'),(86,3,9,5,'2024-01-12'),(86,4,3,5,'2024-01-05'),
(86,5,6,5,'2024-01-09'),(86,6,4,5,'2024-01-11'),(86,7,8,5,'2024-01-07'),(86,8,2,5,'2024-01-06'),
(86,9,5,5,'2024-01-04'),(86,10,10,5,'2024-01-13'),
(87,1,9,5,'2024-01-10'),(87,2,7,5,'2024-01-08'),(87,3,11,5,'2024-01-12'),(87,4,5,5,'2024-01-05'),
(87,5,8,5,'2024-01-09'),(87,6,6,5,'2024-01-11'),(87,7,10,5,'2024-01-07'),(87,8,4,5,'2024-01-06'),
(87,9,7,5,'2024-01-04'),(87,10,12,5,'2024-01-13'),
(88,1,8,5,'2024-01-10'),(88,2,6,5,'2024-01-08'),(88,3,10,5,'2024-01-12'),(88,4,4,5,'2024-01-05'),
(88,5,7,5,'2024-01-09'),(88,6,5,5,'2024-01-11'),(88,7,9,5,'2024-01-07'),(88,8,3,5,'2024-01-06'),
(88,9,6,5,'2024-01-04'),(88,10,11,5,'2024-01-13'),
(89,1,10,5,'2024-01-10'),(89,2,8,5,'2024-01-08'),(89,3,12,5,'2024-01-12'),(89,4,6,5,'2024-01-05'),
(89,5,9,5,'2024-01-09'),(89,6,7,5,'2024-01-11'),(89,7,11,5,'2024-01-07'),(89,8,5,5,'2024-01-06'),
(89,9,8,5,'2024-01-04'),(89,10,13,5,'2024-01-13'),
(90,1,6,5,'2024-01-10'),(90,2,4,5,'2024-01-08'),(90,3,8,5,'2024-01-12'),(90,4,2,5,'2024-01-05'),
(90,5,5,5,'2024-01-09'),(90,6,3,5,'2024-01-11'),(90,7,7,5,'2024-01-07'),(90,8,1,5,'2024-01-06'),
(90,9,4,5,'2024-01-04'),(90,10,9,5,'2024-01-13'),
-- Games 91-100 (Nintendo 3DS)
(91,1,8,5,'2024-01-10'),(91,2,6,5,'2024-01-08'),(91,3,10,5,'2024-01-12'),(91,4,4,5,'2024-01-05'),
(91,5,7,5,'2024-01-09'),(91,6,5,5,'2024-01-11'),(91,7,9,5,'2024-01-07'),(91,8,3,5,'2024-01-06'),
(91,9,6,5,'2024-01-04'),(91,10,11,5,'2024-01-13'),
(92,1,10,5,'2024-01-10'),(92,2,8,5,'2024-01-08'),(92,3,12,5,'2024-01-12'),(92,4,6,5,'2024-01-05'),
(92,5,9,5,'2024-01-09'),(92,6,7,5,'2024-01-11'),(92,7,11,5,'2024-01-07'),(92,8,5,5,'2024-01-06'),
(92,9,8,5,'2024-01-04'),(92,10,13,5,'2024-01-13'),
(93,1,9,5,'2024-01-10'),(93,2,7,5,'2024-01-08'),(93,3,11,5,'2024-01-12'),(93,4,5,5,'2024-01-05'),
(93,5,8,5,'2024-01-09'),(93,6,6,5,'2024-01-11'),(93,7,10,5,'2024-01-07'),(93,8,4,5,'2024-01-06'),
(93,9,7,5,'2024-01-04'),(93,10,12,5,'2024-01-13'),
(94,1,11,5,'2024-01-10'),(94,2,9,5,'2024-01-08'),(94,3,13,5,'2024-01-12'),(94,4,7,5,'2024-01-05'),
(94,5,10,5,'2024-01-09'),(94,6,8,5,'2024-01-11'),(94,7,12,5,'2024-01-07'),(94,8,5,5,'2024-01-06'),
(94,9,9,5,'2024-01-04'),(94,10,14,5,'2024-01-13'),
(95,1,7,5,'2024-01-10'),(95,2,5,5,'2024-01-08'),(95,3,9,5,'2024-01-12'),(95,4,3,5,'2024-01-05'),
(95,5,6,5,'2024-01-09'),(95,6,4,5,'2024-01-11'),(95,7,8,5,'2024-01-07'),(95,8,2,5,'2024-01-06'),
(95,9,5,5,'2024-01-04'),(95,10,10,5,'2024-01-13'),
(96,1,8,5,'2024-01-10'),(96,2,6,5,'2024-01-08'),(96,3,10,5,'2024-01-12'),(96,4,4,5,'2024-01-05'),
(96,5,7,5,'2024-01-09'),(96,6,5,5,'2024-01-11'),(96,7,9,5,'2024-01-07'),(96,8,3,5,'2024-01-06'),
(96,9,6,5,'2024-01-04'),(96,10,11,5,'2024-01-13'),
(97,1,6,5,'2024-01-10'),(97,2,4,5,'2024-01-08'),(97,3,8,5,'2024-01-12'),(97,4,2,5,'2024-01-05'),
(97,5,5,5,'2024-01-09'),(97,6,3,5,'2024-01-11'),(97,7,7,5,'2024-01-07'),(97,8,1,5,'2024-01-06'),
(97,9,4,5,'2024-01-04'),(97,10,9,5,'2024-01-13'),
(98,1,9,5,'2024-01-10'),(98,2,7,5,'2024-01-08'),(98,3,11,5,'2024-01-12'),(98,4,5,5,'2024-01-05'),
(98,5,8,5,'2024-01-09'),(98,6,6,5,'2024-01-11'),(98,7,10,5,'2024-01-07'),(98,8,4,5,'2024-01-06'),
(98,9,7,5,'2024-01-04'),(98,10,12,5,'2024-01-13'),
(99,1,7,5,'2024-01-10'),(99,2,5,5,'2024-01-08'),(99,3,9,5,'2024-01-12'),(99,4,3,5,'2024-01-05'),
(99,5,6,5,'2024-01-09'),(99,6,4,5,'2024-01-11'),(99,7,8,5,'2024-01-07'),(99,8,2,5,'2024-01-06'),
(99,9,5,5,'2024-01-04'),(99,10,10,5,'2024-01-13'),
(100,1,8,5,'2024-01-10'),(100,2,6,5,'2024-01-08'),(100,3,10,5,'2024-01-12'),(100,4,4,5,'2024-01-05'),
(100,5,7,5,'2024-01-09'),(100,6,5,5,'2024-01-11'),(100,7,9,5,'2024-01-07'),(100,8,3,5,'2024-01-06'),
(100,9,6,5,'2024-01-04'),(100,10,11,5,'2024-01-13');

-- 10. BILLS (20 bills across different stores, clients, employees)
INSERT INTO bill (client_id, employee_id, stablishment_id, bill_date, payment_method, status, notes) VALUES
(1,  3,  1, '2024-01-15 10:30:00', 'card', 'completed', NULL),
(5,  5,  2, '2024-01-16 11:45:00', 'cash', 'completed', NULL),
(12, 8,  3, '2024-01-17 14:20:00', 'card', 'completed', NULL),
(23, 11, 4, '2024-01-18 09:15:00', 'transfer', 'completed', NULL),
(34, 14, 5, '2024-01-19 16:00:00', 'card', 'completed', NULL),
(45, 17, 6, '2024-01-20 13:30:00', 'cash', 'completed', NULL),
(56, 20, 7, '2024-01-21 10:00:00', 'card', 'completed', NULL),
(67, 23, 8, '2024-01-22 15:45:00', 'card', 'completed', NULL),
(78, 26, 9, '2024-01-23 12:20:00', 'cash', 'completed', NULL),
(89, 29, 10,'2024-01-24 11:10:00', 'card', 'completed', NULL),
(2,  3,  1, '2024-01-25 14:00:00', 'cash', 'completed', NULL),
(15, 5,  2, '2024-01-26 10:30:00', 'card', 'completed', NULL),
(28, 8,  3, '2024-01-27 16:45:00', 'card', 'completed', NULL),
(41, 11, 4, '2024-01-28 09:00:00', 'transfer', 'completed', NULL),
(54, 14, 5, '2024-01-29 13:15:00', 'cash', 'completed', NULL),
(63, 17, 6, '2024-01-30 11:30:00', 'card', 'completed', NULL),
(72, 20, 7, '2024-02-01 14:20:00', 'card', 'completed', NULL),
(81, 23, 8, '2024-02-02 10:45:00', 'cash', 'completed', NULL),
(93, 26, 9, '2024-02-03 15:00:00', 'card', 'completed', 'Loyalty discount applied'),
(100,29, 10,'2024-02-04 12:30:00', 'card', 'completed', NULL);

-- 11. BILL DETAILS (20 bill details, 1 per bill)
INSERT INTO bill_details (bill_id, game_id, quantity, unit_price) VALUES
(1,  1,  1, 69.99),  -- Zelda: Tears of the Kingdom
(2,  15, 1, 69.99),  -- Spider-Man 2
(3,  8,  2, 59.99),  -- Super Smash Bros Ultimate
(4,  11, 1, 69.99),  -- God of War Ragnarok
(5,  2,  1, 59.99),  -- Super Mario Odyssey
(6,  19, 1, 59.99),  -- Elden Ring
(7,  4,  2, 59.99),  -- Mario Kart 8 Deluxe
(8,  21, 1, 59.99),  -- Halo Infinite
(9,  31, 1, 39.99),  -- God of War (PS4)
(10, 3,  1, 59.99),  -- Pokemon Scarlet
(11, 10, 1, 59.99),  -- Animal Crossing
(12, 12, 1, 69.99),  -- Horizon Forbidden West
(13, 22, 1, 59.99),  -- Forza Horizon 5
(14, 32, 1, 39.99),  -- The Last of Us Part II
(15, 13, 1, 69.99),  -- Final Fantasy XVI
(16, 16, 1, 59.99),  -- Resident Evil 4 Remake
(17, 61, 1, 59.99),  -- Cyberpunk 2077
(18, 29, 1, 69.99),  -- EA Sports FC 24
(19, 81, 1, 49.99),  -- Ghost of Tsushima
(20, 91, 1, 39.99);  -- Pokemon X

-- INVENTORY (10 registros)
INSERT INTO inventory (game_id, stablishment_id, quantity, min_stock, last_restocked) VALUES
(1, 1, 25, 5, '2024-01-15 10:00:00'),
(2, 1, 18, 5, '2024-01-20 11:30:00'),
(3, 2, 30, 5, '2024-01-10 09:15:00'),
(4, 2, 12, 5, '2024-01-18 14:20:00'),
(5, 3, 8, 5, '2024-01-22 16:45:00'),
(6, 3, 22, 5, '2024-01-12 10:00:00'),
(7, 4, 15, 5, '2024-01-25 13:30:00'),
(8, 4, 20, 5, '2024-01-08 12:00:00'),
(9, 5, 10, 5, '2024-01-28 15:15:00'),
(10, 5, 35, 5, '2024-01-05 09:00:00');

-- BILL (10 facturas)
INSERT INTO bill (client_id, employee_id, stablishment_id, bill_date, total_amount, payment_method, status, notes) VALUES
(1, 1, 1, '2024-01-15 14:30:00', 129.98, 'card', 'completed', 'Regular purchase'),
(2, 2, 1, '2024-01-16 11:20:00', 59.99, 'cash', 'completed', NULL),
(3, 4, 2, '2024-01-16 16:45:00', 139.98, 'card', 'completed', 'Holiday sale'),
(4, 5, 2, '2024-01-17 10:15:00', 89.97, 'transfer', 'completed', 'First purchase'),
(5, 7, 3, '2024-01-17 15:30:00', 209.97, 'card', 'completed', 'Bundle discount'),
(6, 8, 3, '2024-01-18 12:00:00', 39.99, 'cash', 'completed', NULL),
(7, 10, 4, '2024-01-18 17:20:00', 69.99, 'card', 'completed', 'Birthday gift'),
(8, 11, 4, '2024-01-19 09:45:00', 119.98, 'transfer', 'pending', 'Awaiting payment confirmation'),
(9, 13, 5, '2024-01-19 14:10:00', 49.99, 'cash', 'completed', NULL),
(10, 14, 5, '2024-01-20 11:00:00', 179.97, 'card', 'completed', 'Premium membership included');

-- BILL DETAILS (10 facturas)
INSERT INTO bill_details (bill_id, game_id, quantity, unit_price) VALUES
(1, 1, 1, 69.99),
(1, 2, 1, 59.99),
(2, 3, 1, 59.99),
(3, 4, 2, 69.99),
(4, 5, 3, 29.99),
(5, 6, 3, 69.99),
(6, 7, 1, 39.99),
(7, 8, 1, 69.99),
(8, 9, 2, 59.99),
(9, 10, 1, 49.99);

-- Insertar registros de auditoría
INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_by_id, ip_address, user_agent, changed_at) VALUES
('roles', 'INSERT', 1, NULL, '{"role_id":1,"role_name":"Admin","description":"Full system access","role_status":"active"}', 'system@install.com', 1, '127.0.0.1', 'MySQL Workbench', '2024-01-15 08:00:00'),
('roles', 'INSERT', 2, NULL, '{"role_id":2,"role_name":"Store Manager","description":"Manages store operations","role_status":"active"}', 'system@install.com', 1, '127.0.0.1', 'MySQL Workbench', '2024-01-15 08:00:01'),
('stablishment', 'INSERT', 1, NULL, '{"stablishment_id":1,"stablishment_name":"GameStore Downtown","city":"New York","stablishment_status":"active"}', 'admin@system.com', 1, '192.168.1.100', 'Web App', '2024-01-15 09:00:00'),
('employees', 'INSERT', 1, NULL, '{"employee_id":1,"first_name":"John","last_name":"Smith","role_id":1}', 'admin@system.com', 1, '192.168.1.100', 'Web App', '2024-01-15 10:00:00'),
('games', 'INSERT', 1, NULL, '{"game_id":1,"game_name":"The Legend of Zelda","price":69.99,"game_status":"active"}', 'inventory@system.com', 4, '192.168.1.50', 'Inventory System', '2024-01-16 08:30:00'),
('inventory', 'UPDATE', 1, '{"quantity":20}', '{"quantity":25}', 'store_manager@downtown.com', 2, '192.168.1.10', 'Store System', '2024-01-16 10:15:00'),
('bill', 'INSERT', 1, NULL, '{"bill_id":1,"client_id":1,"total_amount":129.98,"payment_method":"card","status":"completed"}', 'cashier@downtown.com', 3, '192.168.1.15', 'POS System', '2024-01-15 14:30:00'),
('bill_details', 'INSERT', 1, NULL, '{"detail_id":1,"bill_id":1,"game_id":1,"quantity":1,"unit_price":69.99}', 'cashier@downtown.com', 3, '192.168.1.15', 'POS System', '2024-01-15 14:30:01'),
('games', 'UPDATE', 1, '{"price":59.99}', '{"price":69.99}', 'admin@system.com', 1, '192.168.1.100', 'Web App', '2024-01-17 09:00:00'),
('employees', 'UPDATE', 15, '{"employee_status":"active"}', '{"employee_status":"on_leave"}', 'hr@system.com', 1, '192.168.1.100', 'HR System', '2024-01-18 14:00:00'),
('clients', 'UPDATE', 25, '{"client_status":"active"}', '{"client_status":"banned"}', 'security@system.com', 2, '192.168.1.100', 'Security System', '2024-01-18 16:30:00'),
('bill', 'UPDATE', 8, '{"status":"pending"}', '{"status":"cancelled"}', 'cashier@centralplaza.com', 17, '192.168.1.45', 'POS System', '2024-01-19 10:00:00'),
('suppliers', 'UPDATE', 4, '{"supplier_status":"active"}', '{"supplier_status":"suspended"}', 'admin@system.com', 1, '192.168.1.100', 'Web App', '2024-01-20 11:00:00'),
('inventory', 'UPDATE', 5, '{"quantity":3}', '{"quantity":8}', 'inventory_clerk@northmall.com', 9, '192.168.1.35', 'Inventory System', '2024-01-20 15:30:00'),
('games', 'DELETE', 95, '{"game_id":95,"game_name":"Outdated Game"}', NULL, 'admin@system.com', 1, '192.168.1.100', 'Web App', '2024-01-21 09:00:00'),
('consoles', 'UPDATE', 9, '{"console_status":"active"}', '{"console_status":"discontinued"}', 'admin@system.com', 1, '192.168.1.100', 'Web App', '2024-01-21 10:30:00');

-- Ver los registros de auditoría
SELECT * FROM audit_log ORDER BY changed_at DESC;

-- 4. VIEWS --
-- ## 1. GAMES COMPLETE
CREATE VIEW view_games_complete AS
SELECT 
    g.game_id,
    g.game_name,
    c.console_name,
    cat.category_name,
    g.developer,
    g.publisher,
    g.release_date,
    g.price,
    s.supplier_name,
    g.description,
    g.game_status
FROM games g
LEFT JOIN consoles c ON g.console_id = c.console_id
LEFT JOIN categories cat ON g.category_id = cat.category_id
LEFT JOIN suppliers s ON g.supplier_id = s.supplier_id;

-- ## 2. INVENTORY PER STABLISHMENT
CREATE VIEW view_inventory_current AS
SELECT 
    i.inventory_id,
    g.game_name,
    c.console_name,
    s.stablishment_name,
    i.quantity,
    i.min_stock,
    CASE 
        WHEN i.quantity <= i.min_stock THEN 'Low stock'
        WHEN i.quantity = 0 THEN 'Out of stock'
        ELSE 'Sufficient stock'
    END AS stock_status,
    i.last_restocked,
    i.updated_at AS last_updated
FROM inventory i
INNER JOIN games g ON i.game_id = g.game_id
INNER JOIN consoles c ON g.console_id = c.console_id
INNER JOIN stablishment s ON i.stablishment_id = s.stablishment_id
WHERE g.game_status = 'active';

-- ## 3. SALES DETAILS
CREATE VIEW view_sales_details AS
SELECT 
    b.bill_id,
    b.bill_date,
    CONCAT(cl.first_name, ' ', cl.last_name) AS client_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    s.stablishment_name,
    b.total_amount,
    b.payment_method,
    b.status,
    COUNT(bd.detail_id) AS items_count,
    SUM(bd.quantity) AS total_units
FROM bill b
INNER JOIN clients cl ON b.client_id = cl.client_id
INNER JOIN employees e ON b.employee_id = e.employee_id
INNER JOIN stablishment s ON b.stablishment_id = s.stablishment_id
INNER JOIN bill_details bd ON b.bill_id = bd.bill_id
GROUP BY b.bill_id;

-- ## 4. INVENTORY ALERT FOR LOW STOCK
CREATE VIEW view_inventory_alerts AS
SELECT 
    i.inventory_id,
    g.game_name,
    c.console_name,
    s.stablishment_name,
    i.quantity,
    i.min_stock,
    (i.min_stock - i.quantity) AS missing_units,
    CASE 
        WHEN i.quantity = 0 THEN 'URGENT - Out of stock'
        WHEN i.quantity <= i.min_stock THEN 'Alert - Low stock'
    END AS alert_level,
    i.last_restocked
FROM inventory i
INNER JOIN games g ON i.game_id = g.game_id
INNER JOIN consoles c ON g.console_id = c.console_id
INNER JOIN stablishment s ON i.stablishment_id = s.stablishment_id
WHERE i.quantity <= i.min_stock
ORDER BY i.quantity ASC;

-- ## 5. TOP SELL'D GAMES
CREATE VIEW view_top_games AS
SELECT 
    g.game_id,
    g.game_name,
    c.console_name,
    cat.category_name,
    COUNT(bd.detail_id) AS times_sold,
    SUM(bd.quantity) AS units_sold,
    SUM(bd.subtotal) AS total_revenue,
    g.price AS current_price
FROM games g
INNER JOIN bill_details bd ON g.game_id = bd.game_id
INNER JOIN bill b ON bd.bill_id = b.bill_id
INNER JOIN consoles c ON g.console_id = c.console_id
INNER JOIN categories cat ON g.category_id = cat.category_id
WHERE b.status = 'completed'
GROUP BY g.game_id
ORDER BY units_sold DESC;

-- ## 6. CLIENTS SUMMARY
CREATE VIEW view_clients_summary AS
SELECT 
    cl.client_id,
    CONCAT(cl.first_name, ' ', cl.last_name) AS full_name,
    cl.email,
    cl.phone,
    COUNT(b.bill_id) AS total_purchases,
    SUM(b.total_amount) AS total_spent,
    AVG(b.total_amount) AS avg_purchase,
    MAX(b.bill_date) AS last_purchase,
    cl.client_status,
    DATEDIFF(CURDATE(), MAX(b.bill_date)) AS days_since_last_purchase
FROM clients cl
LEFT JOIN bill b ON cl.client_id = b.client_id AND b.status = 'completed'
GROUP BY cl.client_id;

-- ## 7. DAILY SALES PER STABLISHMENT
CREATE VIEW view_daily_sales AS
SELECT 
    DATE(b.bill_date) AS sale_date,
    s.stablishment_name,
    COUNT(b.bill_id) AS total_sales,
    SUM(b.total_amount) AS total_revenue,
    AVG(b.total_amount) AS avg_ticket,
    COUNT(DISTINCT b.client_id) AS unique_customers
FROM bill b
INNER JOIN stablishment s ON b.stablishment_id = s.stablishment_id
WHERE b.status = 'completed'
GROUP BY DATE(b.bill_date), s.stablishment_id;

-- ## 8. SUPPLIER WITH PRODUCTS
CREATE VIEW view_suppliers_products AS
SELECT 
    s.supplier_id,
    s.supplier_name,
    s.contact_name,
    s.email,
    s.phone,
    COUNT(g.game_id) AS total_products,
    MIN(g.price) AS min_price,
    MAX(g.price) AS max_price,
    AVG(g.price) AS avg_price,
    s.supplier_status
FROM suppliers s
LEFT JOIN games g ON s.supplier_id = g.supplier_id
WHERE g.game_status = 'active'
GROUP BY s.supplier_id;

-- ## 9. MONTHLY FINANCIAL SUMAMRY
CREATE VIEW view_monthly_financial_summary AS
SELECT 
    YEAR(b.bill_date) AS year,
    MONTH(b.bill_date) AS month,
    DATE_FORMAT(b.bill_date, '%Y-%m') AS period,
    COUNT(b.bill_id) AS total_transactions,
    SUM(b.total_amount) AS total_revenue,
    AVG(b.total_amount) AS avg_ticket,
    SUM(CASE WHEN b.payment_method = 'cash' THEN b.total_amount ELSE 0 END) AS cash_revenue,
    SUM(CASE WHEN b.payment_method = 'card' THEN b.total_amount ELSE 0 END) AS card_revenue,
    SUM(CASE WHEN b.payment_method = 'transfer' THEN b.total_amount ELSE 0 END) AS transfer_revenue
FROM bill b
WHERE b.status = 'completed'
GROUP BY YEAR(b.bill_date), MONTH(b.bill_date)
ORDER BY year DESC, month DESC;

-- 5. STORED PROCEDURES --
DELIMITER $$
-- ## 1. ROLES 
CREATE PROCEDURE sp_roles_create(IN p_name VARCHAR(50), IN p_description VARCHAR(255))
BEGIN
    INSERT INTO roles (role_name, description) VALUES (p_name, p_description);
    SELECT LAST_INSERT_ID() AS role_id;
END$$
 
CREATE PROCEDURE sp_roles_read(IN p_role_id INT UNSIGNED)
BEGIN
    IF p_role_id IS NULL THEN
        SELECT * FROM roles WHERE role_status = 'active';
    ELSE
        SELECT * FROM roles WHERE role_id = p_role_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_roles_update(IN p_role_id INT UNSIGNED, IN p_name VARCHAR(50), IN p_description VARCHAR(255), IN p_status ENUM('active','inactive'))
BEGIN
    UPDATE roles SET role_name = p_name, description = p_description, role_status = p_status WHERE role_id = p_role_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_roles_delete(IN p_role_id INT UNSIGNED)
BEGIN
    IF EXISTS (SELECT 1 FROM employees WHERE role_id = p_role_id AND employee_status = 'active') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot deactivate a role assigned to active employees.';
    END IF;
    UPDATE roles SET role_status = 'inactive' WHERE role_id = p_role_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 2. STABLISHMENT
CREATE PROCEDURE sp_stablishment_create(IN p_name VARCHAR(100), IN p_address VARCHAR(255), IN p_city VARCHAR(100), IN p_state VARCHAR(100), IN p_country VARCHAR(100), IN p_phone VARCHAR(20), IN p_email VARCHAR(100))
BEGIN
    INSERT INTO stablishment (stablishment_name, address, city, state, country, phone, email)
    VALUES (p_name, p_address, p_city, p_state, p_country, p_phone, p_email);
    SELECT LAST_INSERT_ID() AS stablishment_id;
END$$
 
CREATE PROCEDURE sp_stablishment_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN
        SELECT * FROM stablishment WHERE stablishment_status = 'active';
    ELSE
        SELECT * FROM stablishment WHERE stablishment_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_stablishment_update(IN p_id INT UNSIGNED, IN p_name VARCHAR(100), IN p_address VARCHAR(255), IN p_city VARCHAR(100), IN p_state VARCHAR(100), IN p_country VARCHAR(100), IN p_phone VARCHAR(20), IN p_email VARCHAR(100), IN p_status ENUM('active','inactive','suspended'))
BEGIN
    UPDATE stablishment SET stablishment_name=p_name, address=p_address, city=p_city, state=p_state, country=p_country, phone=p_phone, email=p_email, stablishment_status=p_status WHERE stablishment_id=p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_stablishment_delete(IN p_id INT UNSIGNED)
BEGIN
    UPDATE stablishment SET stablishment_status = 'inactive' WHERE stablishment_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 3. EMPLOYEES
CREATE PROCEDURE sp_employees_create(IN p_stablishment_id INT UNSIGNED, IN p_role_id INT UNSIGNED, IN p_first_name VARCHAR(100), IN p_last_name VARCHAR(100), IN p_email VARCHAR(150), IN p_phone VARCHAR(20), IN p_hire_date DATE, IN p_salary DECIMAL(10,2))
BEGIN
    INSERT INTO employees (stablishment_id, role_id, first_name, last_name, email, phone, hire_date, salary)
    VALUES (p_stablishment_id, p_role_id, p_first_name, p_last_name, p_email, p_phone, p_hire_date, p_salary);
    SELECT LAST_INSERT_ID() AS employee_id;
END$$
 
CREATE PROCEDURE sp_employees_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN
        SELECT e.*, r.role_name, s.stablishment_name
        FROM employees e
        JOIN roles r ON e.role_id = r.role_id
        JOIN stablishment s ON e.stablishment_id = s.stablishment_id
        WHERE e.employee_status = 'active';
    ELSE
        SELECT e.*, r.role_name, s.stablishment_name
        FROM employees e
        JOIN roles r ON e.role_id = r.role_id
        JOIN stablishment s ON e.stablishment_id = s.stablishment_id
        WHERE e.employee_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_employees_update(IN p_id INT UNSIGNED, IN p_stablishment_id INT UNSIGNED, IN p_role_id INT UNSIGNED, IN p_first_name VARCHAR(100), IN p_last_name VARCHAR(100), IN p_email VARCHAR(150), IN p_phone VARCHAR(20), IN p_salary DECIMAL(10,2), IN p_status ENUM('active','inactive','suspended','on_leave'))
BEGIN
    UPDATE employees SET stablishment_id=p_stablishment_id, role_id=p_role_id, first_name=p_first_name, last_name=p_last_name, email=p_email, phone=p_phone, salary=p_salary, employee_status=p_status WHERE employee_id=p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_employees_delete(IN p_id INT UNSIGNED)
BEGIN
    UPDATE employees SET employee_status = 'inactive' WHERE employee_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 4. CLIENTS
CREATE PROCEDURE sp_clients_create(IN p_first_name VARCHAR(100), IN p_last_name VARCHAR(100), IN p_email VARCHAR(150), IN p_phone VARCHAR(20), IN p_birthdate DATE, IN p_address VARCHAR(255))
BEGIN
    INSERT INTO clients (first_name, last_name, email, phone, birthdate, address)
    VALUES (p_first_name, p_last_name, p_email, p_phone, p_birthdate, p_address);
    SELECT LAST_INSERT_ID() AS client_id;
END$$
 
CREATE PROCEDURE sp_clients_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN
        SELECT * FROM clients WHERE client_status = 'active';
    ELSE
        SELECT * FROM clients WHERE client_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_clients_update(IN p_id INT UNSIGNED, IN p_first_name VARCHAR(100), IN p_last_name VARCHAR(100), IN p_email VARCHAR(150), IN p_phone VARCHAR(20), IN p_birthdate DATE, IN p_address VARCHAR(255), IN p_status ENUM('active','inactive','banned'))
BEGIN
    UPDATE clients SET first_name=p_first_name, last_name=p_last_name, email=p_email, phone=p_phone, birthdate=p_birthdate, address=p_address, client_status=p_status WHERE client_id=p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_clients_delete(IN p_id INT UNSIGNED)
BEGIN
    UPDATE clients SET client_status = 'inactive' WHERE client_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 5. SUPPLIERS
CREATE PROCEDURE sp_suppliers_create(IN p_name VARCHAR(150), IN p_contact VARCHAR(150), IN p_email VARCHAR(150), IN p_phone VARCHAR(20), IN p_address VARCHAR(255))
BEGIN
    INSERT INTO suppliers (supplier_name, contact_name, email, phone, address)
    VALUES (p_name, p_contact, p_email, p_phone, p_address);
    SELECT LAST_INSERT_ID() AS supplier_id;
END$$
 
CREATE PROCEDURE sp_suppliers_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN SELECT * FROM suppliers WHERE supplier_status = 'active';
    ELSE SELECT * FROM suppliers WHERE supplier_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_suppliers_update(IN p_id INT UNSIGNED, IN p_name VARCHAR(150), IN p_contact VARCHAR(150), IN p_email VARCHAR(150), IN p_phone VARCHAR(20), IN p_address VARCHAR(255), IN p_status ENUM('active','inactive','suspended'))
BEGIN
    UPDATE suppliers SET supplier_name=p_name, contact_name=p_contact, email=p_email, phone=p_phone, address=p_address, supplier_status=p_status WHERE supplier_id=p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_suppliers_delete(IN p_id INT UNSIGNED)
BEGIN
    UPDATE suppliers SET supplier_status = 'inactive' WHERE supplier_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 6. CONSOLES
CREATE PROCEDURE sp_consoles_create(IN p_name VARCHAR(100), IN p_manufacturer VARCHAR(100), IN p_release_year YEAR)
BEGIN
    INSERT INTO consoles (console_name, manufacturer, release_year) VALUES (p_name, p_manufacturer, p_release_year);
    SELECT LAST_INSERT_ID() AS console_id;
END$$
 
CREATE PROCEDURE sp_consoles_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN SELECT * FROM consoles WHERE console_status = 'active';
    ELSE SELECT * FROM consoles WHERE console_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_consoles_update(IN p_id INT UNSIGNED, IN p_name VARCHAR(100), IN p_manufacturer VARCHAR(100), IN p_release_year YEAR, IN p_status ENUM('active','inactive','discontinued'))
BEGIN
    UPDATE consoles SET console_name=p_name, manufacturer=p_manufacturer, release_year=p_release_year, console_status=p_status WHERE console_id=p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_consoles_delete(IN p_id INT UNSIGNED)
BEGIN
    IF EXISTS (SELECT 1 FROM games WHERE console_id = p_id AND game_status = 'active') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot deactivate a console that has active games.';
    END IF;
    UPDATE consoles SET console_status = 'inactive' WHERE console_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 7. CATEGORIES
CREATE PROCEDURE sp_categories_create(IN p_name VARCHAR(100), IN p_description VARCHAR(255))
BEGIN
    INSERT INTO categories (category_name, description) VALUES (p_name, p_description);
    SELECT LAST_INSERT_ID() AS category_id;
END$$
 
CREATE PROCEDURE sp_categories_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN SELECT * FROM categories WHERE category_status = 'active';
    ELSE SELECT * FROM categories WHERE category_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_categories_update(IN p_id INT UNSIGNED, IN p_name VARCHAR(100), IN p_description VARCHAR(255), IN p_status ENUM('active','inactive'))
BEGIN
    UPDATE categories SET category_name=p_name, description=p_description, category_status=p_status WHERE category_id=p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_categories_delete(IN p_id INT UNSIGNED)
BEGIN
    IF EXISTS (SELECT 1 FROM games WHERE category_id = p_id AND game_status = 'active') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot deactivate a category that has active games.';
    END IF;
    UPDATE categories SET category_status = 'inactive' WHERE category_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 8. GAMES
CREATE PROCEDURE sp_games_create(IN p_console_id INT UNSIGNED, IN p_category_id INT UNSIGNED, IN p_supplier_id INT UNSIGNED, IN p_name VARCHAR(200), IN p_developer VARCHAR(150), IN p_publisher VARCHAR(150), IN p_release_date DATE, IN p_price DECIMAL(10,2), IN p_description TEXT)
BEGIN
    INSERT INTO games (console_id, category_id, supplier_id, game_name, developer, publisher, release_date, price, description)
    VALUES (p_console_id, p_category_id, p_supplier_id, p_name, p_developer, p_publisher, p_release_date, p_price, p_description);
    SELECT LAST_INSERT_ID() AS game_id;
END$$
 
CREATE PROCEDURE sp_games_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN
        SELECT g.*, c.console_name, cat.category_name, s.supplier_name
        FROM games g
        JOIN consoles c ON g.console_id = c.console_id
        JOIN categories cat ON g.category_id = cat.category_id
        LEFT JOIN suppliers s ON g.supplier_id = s.supplier_id
        WHERE g.game_status = 'active';
    ELSE
        SELECT g.*, c.console_name, cat.category_name, s.supplier_name
        FROM games g
        JOIN consoles c ON g.console_id = c.console_id
        JOIN categories cat ON g.category_id = cat.category_id
        LEFT JOIN suppliers s ON g.supplier_id = s.supplier_id
        WHERE g.game_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_games_update(IN p_id INT UNSIGNED, IN p_console_id INT UNSIGNED, IN p_category_id INT UNSIGNED, IN p_supplier_id INT UNSIGNED, IN p_name VARCHAR(200), IN p_developer VARCHAR(150), IN p_publisher VARCHAR(150), IN p_release_date DATE, IN p_price DECIMAL(10,2), IN p_description TEXT, IN p_status ENUM('active','inactive','discontinued','out_of_stock'))
BEGIN
    UPDATE games SET console_id=p_console_id, category_id=p_category_id, supplier_id=p_supplier_id, game_name=p_name, developer=p_developer, publisher=p_publisher, release_date=p_release_date, price=p_price, description=p_description, game_status=p_status WHERE game_id=p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_games_delete(IN p_id INT UNSIGNED)
BEGIN
    UPDATE games SET game_status = 'inactive' WHERE game_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 9. INVENTORY
CREATE PROCEDURE sp_inventory_create(IN p_game_id INT UNSIGNED, IN p_stablishment_id INT UNSIGNED, IN p_quantity INT, IN p_min_stock INT)
BEGIN
    INSERT INTO inventory (game_id, stablishment_id, quantity, min_stock, last_restocked)
    VALUES (p_game_id, p_stablishment_id, p_quantity, p_min_stock, NOW());
    SELECT LAST_INSERT_ID() AS inventory_id;
END$$
 
CREATE PROCEDURE sp_inventory_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN
        SELECT i.*, g.game_name, s.stablishment_name
        FROM inventory i
        JOIN games g ON i.game_id = g.game_id
        JOIN stablishment s ON i.stablishment_id = s.stablishment_id;
    ELSE
        SELECT i.*, g.game_name, s.stablishment_name
        FROM inventory i
        JOIN games g ON i.game_id = g.game_id
        JOIN stablishment s ON i.stablishment_id = s.stablishment_id
        WHERE i.inventory_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_inventory_update(IN p_id INT UNSIGNED, IN p_quantity INT, IN p_min_stock INT)
BEGIN
    UPDATE inventory
    SET quantity       = p_quantity,
        min_stock      = p_min_stock,
        last_restocked = IF(p_quantity > (SELECT quantity FROM (SELECT quantity FROM inventory WHERE inventory_id = p_id) AS tmp), NOW(), last_restocked)
    WHERE inventory_id = p_id;
 
    -- If restocked, flip game back to active if it was out_of_stock
    IF p_quantity > 0 THEN
        UPDATE games SET game_status = 'active'
        WHERE game_id = (SELECT game_id FROM inventory WHERE inventory_id = p_id)
          AND game_status = 'out_of_stock';
    END IF;
 
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_inventory_delete(IN p_id INT UNSIGNED)
BEGIN
    DELETE FROM inventory WHERE inventory_id = p_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 10. BILL
CREATE PROCEDURE sp_bill_create(IN p_client_id INT UNSIGNED, IN p_employee_id INT UNSIGNED, IN p_stablishment_id INT UNSIGNED, IN p_payment_method ENUM('cash','card','transfer','other'), IN p_notes TEXT)
BEGIN
    INSERT INTO bill (client_id, employee_id, stablishment_id, payment_method, notes)
    VALUES (p_client_id, p_employee_id, p_stablishment_id, p_payment_method, p_notes);
    SELECT LAST_INSERT_ID() AS bill_id;
END$$
 
CREATE PROCEDURE sp_bill_add_item(IN p_bill_id INT UNSIGNED, IN p_game_id INT UNSIGNED, IN p_quantity INT, IN p_unit_price DECIMAL(10,2))
BEGIN
    INSERT INTO bill_details (bill_id, game_id, quantity, unit_price)
    VALUES (p_bill_id, p_game_id, p_quantity, p_unit_price);
END$$
 
CREATE PROCEDURE sp_bill_read(IN p_id INT UNSIGNED)
BEGIN
    IF p_id IS NULL THEN
        SELECT b.*, CONCAT(c.first_name,' ',c.last_name) AS client_name, CONCAT(e.first_name,' ',e.last_name) AS employee_name
        FROM bill b
        JOIN clients c   ON b.client_id   = c.client_id
        JOIN employees e ON b.employee_id  = e.employee_id;
    ELSE
        SELECT b.*, CONCAT(c.first_name,' ',c.last_name) AS client_name, CONCAT(e.first_name,' ',e.last_name) AS employee_name,
               bd.game_id, g.game_name, bd.quantity, bd.unit_price, bd.subtotal
        FROM bill b
        JOIN clients c      ON b.client_id   = c.client_id
        JOIN employees e    ON b.employee_id  = e.employee_id
        JOIN bill_details bd ON b.bill_id     = bd.bill_id
        JOIN games g        ON bd.game_id     = g.game_id
        WHERE b.bill_id = p_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_bill_cancel(IN p_bill_id INT UNSIGNED)
BEGIN
    IF (SELECT status FROM bill WHERE bill_id = p_bill_id) = 'cancelled' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bill is already cancelled.';
    END IF;
    UPDATE bill SET status = 'cancelled' WHERE bill_id = p_bill_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 11. BILL DETAILS
CREATE PROCEDURE sp_bill_details_create(IN p_bill_id INT UNSIGNED, IN p_game_id INT UNSIGNED, IN p_quantity INT, IN p_unit_price DECIMAL(10,2))
BEGIN
    DECLARE v_stablishment_id INT UNSIGNED;
    DECLARE v_stock INT;
    SELECT stablishment_id INTO v_stablishment_id FROM bill WHERE bill_id = p_bill_id;
    SELECT quantity INTO v_stock FROM inventory WHERE game_id = p_game_id AND stablishment_id = v_stablishment_id;
    IF v_stock IS NULL OR v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for this game in the selected establishment.';
    END IF;
    INSERT INTO bill_details (bill_id, game_id, quantity, unit_price) VALUES (p_bill_id, p_game_id, p_quantity, p_unit_price);
    UPDATE inventory SET quantity = quantity - p_quantity WHERE game_id = p_game_id AND stablishment_id = v_stablishment_id;
    UPDATE games SET game_status = 'out_of_stock' WHERE game_id = p_game_id AND (SELECT quantity FROM inventory WHERE game_id = p_game_id AND stablishment_id = v_stablishment_id) = 0;
    UPDATE bill SET total_amount = (SELECT COALESCE(SUM(subtotal), 0) FROM bill_details WHERE bill_id = p_bill_id) WHERE bill_id = p_bill_id;
    SELECT LAST_INSERT_ID() AS detail_id;
END$$
 
CREATE PROCEDURE sp_bill_details_read(IN p_id INT UNSIGNED, IN p_bill_id INT UNSIGNED)
BEGIN
    IF p_id IS NOT NULL THEN
        SELECT bd.*, g.game_name, c.console_name FROM bill_details bd JOIN games g ON bd.game_id = g.game_id JOIN consoles c ON g.console_id = c.console_id WHERE bd.detail_id = p_id;
    ELSEIF p_bill_id IS NOT NULL THEN
        SELECT bd.*, g.game_name, c.console_name FROM bill_details bd JOIN games g ON bd.game_id = g.game_id JOIN consoles c ON g.console_id = c.console_id WHERE bd.bill_id = p_bill_id;
    ELSE
        SELECT bd.*, g.game_name, b.bill_date FROM bill_details bd JOIN games g ON bd.game_id = g.game_id JOIN bill b ON bd.bill_id = b.bill_id;
    END IF;
END$$
 
CREATE PROCEDURE sp_bill_details_update(IN p_id INT UNSIGNED, IN p_quantity INT, IN p_unit_price DECIMAL(10,2))
BEGIN
    DECLARE v_bill_id INT UNSIGNED;
    DECLARE v_bill_status VARCHAR(20);
    DECLARE v_game_id INT UNSIGNED;
    DECLARE v_stablishment_id INT UNSIGNED;
    DECLARE v_old_quantity INT;
    SELECT bill_id, game_id, quantity INTO v_bill_id, v_game_id, v_old_quantity FROM bill_details WHERE detail_id = p_id;
    SELECT status, stablishment_id INTO v_bill_status, v_stablishment_id FROM bill WHERE bill_id = v_bill_id;
    IF v_bill_status NOT IN ('pending', 'completed') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot edit details of a cancelled or refunded bill.';
    END IF;
    IF p_quantity > v_old_quantity AND (SELECT quantity FROM inventory WHERE game_id = v_game_id AND stablishment_id = v_stablishment_id) < (p_quantity - v_old_quantity) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock to increase quantity.';
    END IF;
    UPDATE inventory SET quantity = quantity - (p_quantity - v_old_quantity) WHERE game_id = v_game_id AND stablishment_id = v_stablishment_id;
    UPDATE bill_details SET quantity = p_quantity, unit_price = p_unit_price WHERE detail_id = p_id;
    UPDATE bill SET total_amount = (SELECT COALESCE(SUM(subtotal), 0) FROM bill_details WHERE bill_id = v_bill_id) WHERE bill_id = v_bill_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
CREATE PROCEDURE sp_bill_details_delete(IN p_id INT UNSIGNED)
BEGIN
    DECLARE v_bill_id INT UNSIGNED;
    DECLARE v_bill_status VARCHAR(20);
    DECLARE v_game_id INT UNSIGNED;
    DECLARE v_stablishment_id INT UNSIGNED;
    DECLARE v_quantity INT;
    SELECT bill_id, game_id, quantity INTO v_bill_id, v_game_id, v_quantity FROM bill_details WHERE detail_id = p_id;
    SELECT status, stablishment_id INTO v_bill_status, v_stablishment_id FROM bill WHERE bill_id = v_bill_id;
    IF v_bill_status = 'completed' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete details from a completed bill. Cancel the bill first.';
    END IF;
    UPDATE inventory SET quantity = quantity + v_quantity WHERE game_id = v_game_id AND stablishment_id = v_stablishment_id;
    DELETE FROM bill_details WHERE detail_id = p_id;
    UPDATE bill SET total_amount = (SELECT COALESCE(SUM(subtotal), 0) FROM bill_details WHERE bill_id = v_bill_id) WHERE bill_id = v_bill_id;
    SELECT ROW_COUNT() AS rows_affected;
END$$
 
-- ## 12. AUDIT LOG
CREATE PROCEDURE sp_audit_log_create(IN p_table_name VARCHAR(50), IN p_operation ENUM('INSERT','UPDATE','DELETE'), IN p_record_id INT UNSIGNED, IN p_old_data JSON, IN p_new_data JSON, IN p_changed_by VARCHAR(100), IN p_changed_by_id INT UNSIGNED, IN p_ip_address VARCHAR(45), IN p_user_agent TEXT)
BEGIN
    INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data, changed_by, changed_by_id, ip_address, user_agent)
    VALUES (p_table_name, p_operation, p_record_id, p_old_data, p_new_data, p_changed_by, p_changed_by_id, p_ip_address, p_user_agent);
    SELECT LAST_INSERT_ID() AS audit_id;
END$$
 
CREATE PROCEDURE sp_audit_log_read(IN p_audit_id BIGINT UNSIGNED, IN p_table_name VARCHAR(50), IN p_operation ENUM('INSERT','UPDATE','DELETE'), IN p_record_id INT UNSIGNED, IN p_date_from DATETIME, IN p_date_to DATETIME)
BEGIN
    SELECT audit_id, table_name, operation, record_id, old_data, new_data, changed_by, changed_by_id, changed_at, ip_address, user_agent
    FROM audit_log
    WHERE (p_audit_id   IS NULL OR audit_id    = p_audit_id)
      AND (p_table_name IS NULL OR table_name  = p_table_name)
      AND (p_operation  IS NULL OR operation   = p_operation)
      AND (p_record_id  IS NULL OR record_id   = p_record_id)
      AND (p_date_from  IS NULL OR changed_at >= p_date_from)
      AND (p_date_to    IS NULL OR changed_at <= p_date_to)
    ORDER BY changed_at DESC;
END$$
 
CREATE PROCEDURE sp_audit_log_read_history(IN p_table_name VARCHAR(50), IN p_record_id INT UNSIGNED)
BEGIN
    SELECT audit_id, operation, old_data, new_data, changed_by, changed_by_id, changed_at, ip_address
    FROM audit_log
    WHERE table_name = p_table_name AND record_id = p_record_id
    ORDER BY changed_at ASC;
END$$
 
CREATE PROCEDURE sp_audit_log_purge(IN p_older_than DATETIME)
BEGIN
    IF p_older_than IS NULL OR p_older_than >= NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'p_older_than must be a past datetime.';
    END IF;
    DELETE FROM audit_log WHERE changed_at < p_older_than;
    SELECT ROW_COUNT() AS rows_deleted;
END$$

DELIMITER ;