INSERT INTO products (name, description, original_price, sale_price, stock, sale_start, sale_end)
VALUES (
    'Sony WH-1000XM5',
    ' noise cancelling headphones',
    349.99,
    199.99,
    100,
    NOW() - INTERVAL '1 hour',
    NOW() + INTERVAL '5 hours'
);