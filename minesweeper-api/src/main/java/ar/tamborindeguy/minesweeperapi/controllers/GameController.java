package ar.tamborindeguy.minesweeperapi.controllers;

import ar.tamborindeguy.minesweeperapi.model.Game;
import ar.tamborindeguy.minesweeperapi.model.GameParameters;
import ar.tamborindeguy.minesweeperapi.model.Position;
import ar.tamborindeguy.minesweeperapi.services.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("/games")
public class GameController {

    @Autowired
    private GameService gameService;

    @GetMapping(value = "/")
    public List<Game> games() {
        return gameService.findAll();
    }

    @PostMapping(value = "/")
    public ResponseEntity<?> newGame(@RequestBody GameParameters gameParameters) {
        Game game = new Game(gameParameters.getMines(), gameParameters.getColumns(), gameParameters.getRows());
        gameService.saveOrUpdateGame(game);
        return ResponseEntity.ok("id: " + game.getId());
    }

    @GetMapping(value = "/{id}")
    public Game game(@PathVariable("id") String id) {
        return gameService.findGameById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Game Not Found"));
    }

    @PostMapping(value="/{id}/reveal")
    public ResponseEntity<?> reveal(@PathVariable String id, @RequestBody Position position) {
        Optional<Game> optionalGame = gameService.findGameById(id);
        if (optionalGame.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Game not found");
        }
        Game game = optionalGame.get();
        if (game.getCell(position.getColumn(), position.getRow()).isRevealed()) {
            return ResponseEntity.ok("Cell already revealed");
        }
        if (game.reveal(position.getColumn(), position.getRow())) {
            gameService.saveOrUpdateGame(game);
            return ResponseEntity.ok("Cell revealed");
        }
        return ResponseEntity.badRequest().body("Invalid Position");
    }

    @PostMapping(value="/{id}/flag")
    public ResponseEntity<?> flag(@PathVariable String id, @RequestBody Position position, @RequestParam Optional<Boolean> question) {
        Optional<Game> optionalGame = gameService.findGameById(id);
        if (optionalGame.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Game not found");
        }
        Game game = optionalGame.get();
        if (game.getCell(position.getColumn(), position.getRow()).isRevealed()) {
            return ResponseEntity.ok("Cell already flagged");
        }
        if (game.flag(question.orElse(false), position.getColumn(), position.getRow())) {
            gameService.saveOrUpdateGame(game);
            return ResponseEntity.ok(question.map((q) ->"Cell flagged").orElse("Cell marked"));
        }
        return ResponseEntity.badRequest().body("Invalid Position");
    }

}
