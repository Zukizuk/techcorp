import os
import psycopg2 as pg
from dotenv import load_dotenv

load_dotenv('.env.local')
connectionString = os.getenv('POSTGRESQL_CRED')
connection = pg.connect(connectionString)
cursor = connection.cursor()

try:
    # Begin transaction
    connection.autocommit = False
    queryResult = 0
    # Insert a new record in the Orders table
    cursor.execute(
        '''
        INSERT INTO orders (order_date, customer_id, quantity, product_id, total)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING order_id
        ''',
        ('2023-11-01', 6, 1, 101, 1000.00)
    )
    queryResult = cursor.fetchone()[0]
    # print(queryResult)
    cursor.execute('''
        SELECT order_id, product_id, quantity FROM orders WHERE order_id = %s
''', (queryResult,))
    queryResult = cursor.fetchone()
    qty = queryResult[2]
    # Add each item from the order into the OrderDetails table
    # print(queryResult)
    cursor.execute(
        '''
        INSERT INTO order_details (order_id, product_id)
        VALUES (%s, %s)  RETURNING product_id
        ''',
        (queryResult[0], queryResult[1])
    )
    queryResult = cursor.fetchone()
    # print(queryResult)
    # Decrease the quantity in stock for each item in the Products table
    cursor.execute(
        '''
        UPDATE products
        SET stock_quantity = stock_quantity - %s
        WHERE product_id = %s
        ''',
        (qty, queryResult)
    )
    cursor.execute('''
        SELECT product_id, stock_quantity FROM products WHERE product_id = %s
''', (queryResult,))
    # queryResult = cursor.fetchone()
    connection.rollback()
    # Commit transaction
    connection.commit()

except Exception as e:
    print(f'An error occurred: {e}')
    connection.rollback()
finally:
    cursor.close()
    connection.close()
