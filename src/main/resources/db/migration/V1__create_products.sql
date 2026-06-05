CREATE TABLE products(
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    original_price NUMERIC (10,2) NOT NULL,
    sale_price NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL CHECK(stock >= 0), --here this is just guard for and edge case that came through my mind where i thought about ..what about if my code goes wrong and i done some missy logic which lead to overselling..shouldnt iprevent that from db level?? i think yes on every level we should apply the prevention as long as we can do it 


    sale_start TIMESTAMP NOT NULL, --why have we addd this is beacuse wanna represent the active timeframe for a product flash sale pricin
    sale_end TIMESTAMP NOT NULL, --so if its larger than this end the product is now not eligiible for that specifc sale_price
    
    version BIGINT NOT NULL DEFAULT 0,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    

)