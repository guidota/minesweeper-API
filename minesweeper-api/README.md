# Minesweeper API
---
Simple RESTful API corresponding to the classic game of Minesweeper

## Prerequisites

* Java 14
* MongoDB

## Development

You must provide a MONGODB_URI env variable for mongo db connection with the corresponding URI

To  **build** the project execute the following command:
> ./gradlew build

To **run** the project  execute the following command: 
> ./gradlew bootRun

### API Specification

A [raml](minesweeper-api.raml) is provided to generate your clients or import it in Postman

# API documentation version v1
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

