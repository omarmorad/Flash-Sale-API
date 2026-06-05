CREATE TABLE orders (
    id               BIGSERIAL PRIMARY KEY,
    product_id       BIGINT NOT NULL REFERENCES products(id),
    user_id          BIGINT NOT NULL,
    idempotency_key  VARCHAR(255) NOT NULL UNIQUE,       -- preventing  duplicate orders on retry
    quantity         INTEGER NOT NULL DEFAULT 1,
    purchase_price   NUMERIC(10, 2) NOT NULL,
    status           VARCHAR(50) NOT NULL DEFAULT 'CONFIRMED',
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_idempotency_key ON orders(idempotency_key);