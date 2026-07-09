
package com.flashsale.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI flashSaleOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Flash Sale API")
                        .description("High-concurrency limited-inventory purchase engine")
                        .version("v1.0.0"));
    }
}