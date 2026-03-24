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

-- 2. Inventario actual por establecimiento
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

-- 3. Empleados con sus roles y establecimientos

-- 4. Ventas con detalles
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

-- 5. Alertas de inventario (stock bajo)
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

-- 6. Top juegos más vendidos
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

-- 7. Resumen de clientes
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

-- 8. Ventas diarias por establecimiento
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

-- 9. Proveedores con productos
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

-- 10. Resumen financiero mensual
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


-- 1. ROLES

INSERT INTO roles (role_name, description, role_status) VALUES
('Admin', 'Full system access', 'active'),
('Store Manager', 'Manages store operations', 'active'),
('Cashier', 'Handles sales', 'active'),
('Inventory Clerk', 'Manages inventory', 'active'),
('Supervisor', 'Oversees operations', 'active');

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
(2, 4, 2, 'Gran Turismo 7', 'Polyphony Digital', 'Sony', '2022-03-04', 69.99, 'Realistic racing','active');

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