package com.flashsale.entity;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;

@Entity 
@Table(name ="products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "sale_price" , nullable = false ,precision =  10 , scale =2)
    private BigDecimal salePrice;

    @Column(nullable = false)
    private Integer stock;

    @Column(name = "sale_start", nullable = false)
     private Instant saleStart;

    @Column(name = "sale_end", nullable = false)
    private Instant saleEnd;

    @Version
    @Column(nullable = false)
    private Long version;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;
    
}
