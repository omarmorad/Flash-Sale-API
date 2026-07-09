package com.flashsale;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
public class FlashSaleApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(FlashSaleApiApplication.class, args);
        System.out.println("omar");
    }

}
