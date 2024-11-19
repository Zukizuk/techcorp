CREATE TABLE IF NOT EXISTS part_three.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    stock_quantity INT NOT NULL 
);

INSERT INTO part_three.products (product_id, product_name, stock_quantity) VALUES (101, 'TechCorpSmart Speaker', 10);

-- Implement row-level locking to prevent conflict
-- Alex's transaction
-- Transaction 1
BEGIN;
SELECT * FROM part_three.products WHERE product_id = 101 FOR UPDATE;
UPDATE part_three.products SET stock_quantity = stock_quantity - 5 WHERE product_id = 101 AND stock_quantity >= 5;
COMMIT;

-- Taylor's transaction
-- Transaction 2
BEGIN;
SELECT * FROM part_three.products WHERE product_id = 101 FOR UPDATE;
UPDATE part_three.products SET stock_quantity = stock_quantity - 5 WHERE product_id = 101 AND stock_quantity >= 5;
COMMIT;