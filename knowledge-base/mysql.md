# SQL 80/20 Quick Guide

This covers about 80% of what we need for daily.

**Structured Query Language (SQL)** is used to interact with **Relational Database Management Systems (RDBMS)**. Common RDBMS include MySQL, PostgreSQL, MariaDB, and SQL Server.

---

## Core SQL Operations (DML)
These are the most commonly used commands:

- `SELECT` - Retrieve data from one or more tables.
- `INSERT` - Add new rows to a table.
- `UPDATE` - Modify existing data.
- `DELETE` - Remove data from a table.

### Essential Clauses

- `FROM` - Specify the source table.
- `WHERE` - Filter rows.
- `ORDER BY` - Sort results.
- `GROUP BY` - Group rows.
- `HAVING` - Filter grouped data.
- `LIMIT` - Restrict the number of returned rows.

---

## JOINS (Combining Tables)

- `JOIN` - Returns only matching rows.
- `LEFT JOIN` - Returns all rows from the left table, with matches from the right.

---

## Aggregate Functions

- `COUNT()` - Number of rows.
- `SUM()` - Total value of a column.
- `AVG()` - Average value.
- `MIN()`, `MAX()` - Lowest and highest value.

---

## Data Definition Language (DDL)
Used to **define, modify, or remove** the structure of database objects (e.g., tables, users, databases).

- `CREATE` - Create new objects.
- `ALTER` - Modify existing objects.
- `DROP` - Delete objects permanently.
- `TRUNCATE` - Remove all data from a table (structure remains).

### Table Constraints

- `PRIMARY KEY`, `UNIQUE`, `NOT NULL`, `FOREIGN KEY`
- `AUTO_INCREMENT`
- `ON DELETE CASCADE`

---

## Basic Dummy Schema

```sql
CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  country VARCHAR(50)
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  stock INT DEFAULT 0
);

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  quantity INT,
  order_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

## Data Manipulation

### Insert

```sql
INSERT INTO customers (name, email, country) VALUES ('Alice', 'alice@example.com', 'USA');
```

### Update

```sql
UPDATE customers SET country = 'Canada' WHERE name = 'Charlie';
```

### Delete

```sql
DELETE FROM orders WHERE order_date BETWEEN '2024-05-01' AND '2024-05-31';
```

---

## Example Queries

### Get All Records

```sql
SELECT * FROM customers;
```

### Filtered Results

```sql
SELECT * FROM customers WHERE email LIKE '%diana%' AND country = 'USA';
```

### Sorted Data

```sql
SELECT * FROM products ORDER BY price DESC LIMIT 5;
```

### Aggregated Results

```sql
SELECT customer_id, COUNT(*) AS total_orders FROM orders GROUP BY customer_id;
```

### JOIN with Filters

```sql
SELECT o.order_id, c.name, p.name, o.quantity, p.price, (o.quantity * p.price) AS total_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE c.country = 'USA';
```

### Revenue per Customer

```sql
SELECT c.name, SUM(o.quantity * p.price) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id
HAVING total_spent > 500
ORDER BY total_spent DESC;
```

---

## Database & Table Info

### Check Table Size in MB

```sql
SELECT
  TABLE_NAME AS `Table`,
  ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) AS `Size (MB)`
FROM
  information_schema.TABLES
WHERE
  TABLE_SCHEMA = "<TABLE_NAME>"
  AND TABLE_NAME LIKE '%log%'
ORDER BY
  (DATA_LENGTH + INDEX_LENGTH) DESC;
```

### Show Structure

```sql
SHOW CREATE TABLE table_name;
SHOW COLUMNS FROM table_name;
```

### Show Indexes

```sql
SHOW INDEX FROM table_name WHERE Column_name = 'NAME';
```

---

## System & Admin Queries

```sh
# Login to MySQL
mysql -u'<user>' -p'<pass>' -h'<host>' -P'3306'

# Dump schema only
mysqldump --no-data -u'<user>' -p'<pass>' -h'<host>' -P'3306' -B '<db_name>' > schema.sql

# Load SQL file
source /path/to/filename.sql;

# Exit MySQL
exit; \q;

# Show running processes
SHOW FULL PROCESSLIST;
CALL mysql.rds_kill(PID);

# Privileges
SHOW GRANTS FOR 'user'@'host';
SHOW PRIVILEGES;

# Show logs (if enabled)
SELECT * FROM mysql.slow_log;
SELECT * FROM mysql.general_log;

# Flush permissions
FLUSH PRIVILEGES;
```

---

## User and Permission Management

```sql
-- Create user
CREATE USER 'user'@'host' IDENTIFIED BY 'pass';

-- Grant
GRANT ALL ON *.* TO 'user'@'host' WITH GRANT OPTION;

-- Revoke
REVOKE ALL ON *.* FROM 'user'@'host';

-- Change password
ALTER USER 'user'@'host' IDENTIFIED BY 'newpass';

--
ALTER TABLE table_name MODIFY COLUMN column_name datatype constraints;
```

---

## Housekeeping

```sql
SHOW DATABASES;
SHOW TABLES;
TRUNCATE TABLE table_name;
DROP TABLE table_name;
DROP DATABASE db_name;
DROP USER 'user'@'host';
```

---

## 📚 References
- https://learnsql.com/blog/sql-basics-cheat-sheet/
