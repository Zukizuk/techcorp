-- Alterations
ALTER TABLE products
ADD COLUMN stock_quantity INT NOT NULL DEFAULT 100


BEGIN TRANSACTION;

INSERT INTO orders (order_date, customer_id, quantity, product_id, total)
VALUES ('2023-11-01', 6, 1, 101, 1000.00)
RETURNING order_id;

INSERT INTO order_details (order_id, product_id)
VALUES (currval('orders_order_id_seq'), 101);

UPDATE products
SET stock_quantity = stock_quantity - 1 
WHERE product_id = 101;

COMMIT;