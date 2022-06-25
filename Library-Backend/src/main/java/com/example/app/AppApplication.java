package com.example.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import javax.mail.MessagingException;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;


@SpringBootApplication
public class AppApplication {
	public static void main(String[] args) throws MessagingException, IOException {
		SpringApplication.run(AppApplication.class, args);

	}

}
