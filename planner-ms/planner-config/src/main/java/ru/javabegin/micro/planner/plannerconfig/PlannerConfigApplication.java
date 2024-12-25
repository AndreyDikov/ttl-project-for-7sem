package ru.javabegin.micro.planner.plannerconfig;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;
import org.springframework.boot.SpringApplication;

@SpringBootApplication
@EnableConfigServer
public class PlannerConfigApplication {

    public static void main(String[] args) {
        SpringApplication.run(PlannerConfigApplication.class, args
        );
    }

}
