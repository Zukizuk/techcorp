CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    customer_email VARCHAR(50) NOT NULL,
    customer_address VARCHAR(50) NOT NULL
)

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(50) NOT NULL
)

CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
    category VARCHAR(50) NOT NULL
    supplier_id INT REFERENCES suppliers
)

CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT REFERENCES customers,
    quantity INT NOT NULL,
    product_id INT REFERENCES products,
    -- discuss with Ann about the total column whether it should be here or not because it can be calculated from the price and quantity which violates the normalization rules
    total DECIMAL(12, 2) NOT NULL 
)

CREATE TABLE IF NOT EXISTS order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders,
    product_id INT REFERENCES products
)

