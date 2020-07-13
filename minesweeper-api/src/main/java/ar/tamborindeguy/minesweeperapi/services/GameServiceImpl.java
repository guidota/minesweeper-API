package ar.tamborindeguy.minesweeperapi.services;

import ar.tamborindeguy.minesweeperapi.model.Game;
import ar.tamborindeguy.minesweeperapi.model.GameState;
import ar.tamborindeguy.minesweeperapi.repositories.GameRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class GameServiceImpl implements GameService {

    @Autowired
    GameRepository gameRepository;

    @Override
    public List<Game> findAll() {
        return gameRepository.findAll();
    }

    @Override
    public List<Game> findNotFinished() {
        return gameRepository.findAll()
                .stream()
                .filter(game -> {
                    final GameState state = game.getState();
                    return state != GameState.WON && state != GameState.LOST;
                })
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Game> findGameById(String id) {
        return gameRepository.findById(id);
    }

    @Override
    public void saveOrUpdateGame(Game game) {
        gameRepository.save(game);
    }

    @Override
    public void deleteGame(String id) {
        gameRepository.deleteById(id);
    }
}
