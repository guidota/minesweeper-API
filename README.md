# minesweeper-API
API test

## The Game
Develop the classic game of [Minesweeper](https://en.wikipedia.org/wiki/Minesweeper_(video_game))

## What to build
The following is a list of items (prioritized from most important to least important) we wish to see:
* Design and implement a documented RESTful API for the game (think of a mobile app for your API)
* Implement an API client library for the API designed above. Ideally, in a different language, of your preference, to the one used for the API
* When a cell with no adjacent mines is revealed, all adjacent squares will be revealed (and repeat)
* Ability to 'flag' a cell with a question mark or red flag
* Detect when game is over
* Persistence
* Time tracking
* Ability to start a new game and preserve/resume the old ones
* Ability to select the game parameters: number of rows, columns, and mines
* Ability to support multiple users/accounts

## RESTful API

You will find the sources and documentation on [this folder](minesweeper-api/)

[Public API instance](https://bref-mandarine-95959.herokuapp.com/games)

## Web Application

In order to test this API you can try [this app](https://app-minesweeper.web.app/). 
See sources and documentation on [this folder](minesweeper_app)