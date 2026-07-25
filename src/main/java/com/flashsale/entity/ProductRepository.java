package com.flashsale.repository;

import com.flashsale.entity.Product;
import jakarta.persistence.LockModeType;
import jakarta.persistence.QueryHint;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    /**
     * The concurrency problema.
     *
     * PESSIMISTIC_WRITE translates to SQL:  SELECT ... FOR UPDATE
     *
     * What "FOR UPDATE" does in Postgres:
     *  - Acquires a row-level lock on the matching row
     *  - ANY other transaction trying to read with FOR UPDATE on the same row BLOCKS until we commit/rollback
     *  - Other transactions doing a plain SELECT are NOT blocked (MVCC) — they see the pre-lock snapshot
     *
     * Result: out of 10 concurrent purchase requests, they queue up serially at this line.
     * Each one reads fresh stock, decides if it can fulfill, decrements, commits, releases lock.
     * Zero oversell guaranteed.
     *
     * The 5-second timeout prevents indefinite blocking if a transaction crashes mid-flight.
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @QueryHints({@QueryHint(name = "jakarta.persistence.lock.timeout", value = "5000")})
    @Query("SELECT p FROM Product p WHERE p.id = :id")
    Optional<Product> findByIdForUpdate(@Param("id") Long id);
}