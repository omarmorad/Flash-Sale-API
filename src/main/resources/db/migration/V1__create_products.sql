CREATE TABLE products(
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    original_price NUMERIC (10,2) NOT NULL,
    sale_price NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL CHECK(stock >= 0),

    
)