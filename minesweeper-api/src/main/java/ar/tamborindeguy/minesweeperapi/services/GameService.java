package ar.tamborindeguy.minesweeperapi.services;

import ar.tamborindeguy.minesweeperapi.model.Game;

import java.util.List;
import java.util.Optional;

public interface GameService {

    List<Game> findAll();

    List<Game> findNotFinished();

    Optional<Game> findGameById(String id);

    void saveOrUpdateGame(Game game);

    void deleteGame(String id);

}
