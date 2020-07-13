package ar.tamborindeguy.minesweeperapi.model;

enum GameState {
    WON("won"),
    LOST("lost"),
    NEW("new"),
    STARTED("started");

    private String displayName;

    GameState(String displayName) {
        this.displayName = displayName;
    }

    @Override
    public String toString() {
        return displayName;
    }
}
