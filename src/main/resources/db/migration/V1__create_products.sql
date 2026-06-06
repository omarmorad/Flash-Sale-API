CREATE TABLE products(
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    original_price NUMERIC (10,2) NOT NULL,
    sale_price NUMERIC(10,2) NOT NULL,
    stock INTEGER NOT NULL CHECK(stock >= 0), --here this is just guard for and edge case that came through my mind where i thought about ..what about if my code goes wrong and i done some missy logic which lead to overselling..shouldnt iprevent that from db level?? i think yes on every level we should apply the prevention as long as we can do it 


    sale_start TIMESTAMP NOT NULL, --why have we addd this is beacuse wanna represent the active timeframe for a product flash sale pricin
    sale_end TIMESTAMP NOT NULL, --so if its larger than this end the product is now not eligiible for that specifc sale_price
    --the why ??I used pessimistic locking as the primary strategy because flash sales are a worstcase scenario for optimistic locking  contention is guaranteed, not rare. The @Version column is a fallback safety net in case of edge cases, not the main concurrency mechanism
    version BIGINT NOT NULL DEFAULT 0,-- here we are just flagging ..did anyone just saved between my read and my  save, the versions don't match and my save here in thiscase is rejected

    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP

    /*
    FIRST OPTIMISTIC
    All 10 users read simultaneously:
  stock = 1, version = 5

All 10 users proceed to update:

  UPDATE products
  SET stock = 0, version = 6
  WHERE id = 1 AND version = 5  <== the check

      database processes these one by one internally:

User 1 update: version is still 5 ==> SUCCESS ==> version becomes 6
User 2 update: version is now 6, not 5 ==> FAILS ==> 0 rows updated
User 3 update: version is now 6. not 5 ==> FAILS ===> 0 rows updated
... same for users 4-10
Now what? Users 2-9 got OptimisticLockException. Your code has two choices:
Choice A Retry: Re-read the product, see stock = 0, reject Fine, But you just did 10 reads + 10 attempted writes + 9 retries.... Under 1000 users that's thousands of extra DB operations
Choice B  rreject immediately: Tell the user "something changed, try again" Bad UX The user has to click Buy again manually


second why pessimistiic is better

        User 1 arrives ==> grabs the key (SELECT FOR UPDATE) ==>> enters room
Users 2-9 arrive ==> no key available ==> they WAIT at the door

User 1 inside:
  reads stock = 1
  stock >= 1? yes
  stock = stock - 1 = 0
  creates order
  commits ==> releases key

User 2 gets key ==> enters room
  reads stock = 0
  stock >= 1? NO
  throws OutOfStockException
  releases key

Users 3-9 each get key one by one ==>  same result ==>OutOfStockException

what is the result of this??
 1 order created ...  9 clean rejections ... Zero chance of oversell
The cost: Users 2-9 waited in line Each one waited for the person before them to finish. In a flash sale with 1000 users this line gets long. But every person in line gets a definitive answer not a stupid "try again"

    */
    

)