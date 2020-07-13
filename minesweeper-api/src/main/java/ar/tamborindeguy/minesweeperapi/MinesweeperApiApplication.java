package ar.tamborindeguy.minesweeperapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration;

@SpringBootApplication(exclude = {JacksonAutoConfiguration.class})
public class MinesweeperApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(MinesweeperApiApplication.class, args);
	}
}
