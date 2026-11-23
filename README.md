# Flash Sale API

A Spring Boot backend for flash sales, built around one problem: many users buying the last units of a product at the same time without overselling.

**Status:** work in progress. The database schema, entities, locking repository and Redis setup are in place. The REST controllers and purchase service are not written yet.

## Stack

- Java 21, Spring Boot
- PostgreSQL 16 with Flyway migrations
- Redis 7 (custom `RedisTemplate`, String keys and JSON values)
- Spring Data JPA (Hibernate, `ddl-auto: validate`)
- springdoc OpenAPI (Swagger UI)
- Docker Compose for local Postgres and Redis

## Design decisions

- **Pessimistic locking first.** `ProductRepository.findByIdForUpdate` uses `PESSIMISTIC_WRITE` (`SELECT ... FOR UPDATE`) with a 5 second lock timeout, so concurrent buyers queue on the product row and each gets a definite answer.
- **Optimistic locking as a safety net.** `Product` has a `@Version` column.
- **Database-level guard.** `stock INTEGER NOT NULL CHECK (stock >= 0)` blocks overselling even if application logic is wrong.
- **Idempotent orders.** `orders.idempotency_key` is `UNIQUE`, so a retried request cannot create a duplicate order.
- **Sale window.** Each product has `sale_start` and `sale_end`.

## Schema

Migrations are in `src/main/resources/db/migration`:

1. `V1__create_products.sql`
2. `V2__create_orders.sql`
3. `V3__seed_data.sql` (one sample product)

## Run locally

```bash
docker compose up -d      # Postgres on 5433, Redis on 6379 (local development credentials in docker-compose.yml)
./mvnw spring-boot:run    # API on http://localhost:8080
```

Swagger UI is configured through springdoc.

## Roadmap

- Purchase endpoint using the locked read
- Redis stock cache and idempotency keys (TTLs are already in `application.yaml`)
- Concurrency tests
