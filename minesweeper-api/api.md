# Minesweeper API documentation version v1
---

### /games

* **get**: Retrieve all games
* **post**: Starts a new game with given parameters

### /games/{id}

* **get**: Retrieve game state
* **delete**: Deletes a game

### /games/{id}/reveal

* **post**: Reveals a cell

### /games/{id}/flag

* **post**: Flags a cell with question mark or red flag

