package ar.tamborindeguy.minesweeperapi;

import ar.tamborindeguy.minesweeperapi.model.Game;
import ar.tamborindeguy.minesweeperapi.serializer.GameJsonSerializer;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnClass(Gson.class)
public class GsonConfig {

    @Bean
    public Gson gson() {
        return new GsonBuilder()
                .registerTypeAdapter(Game.class, new GameJsonSerializer())
                .create();
    }
}
