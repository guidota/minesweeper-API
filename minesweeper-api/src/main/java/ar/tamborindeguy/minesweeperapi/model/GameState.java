package ar.tamborindeguy.minesweeperapi.model;

public enum GameState {
    WON("won"),
    LOST("lost"),
    NEW("new"),
    STARTED("started");

    private final String displayName;

    GameState(String displayName) {
        this.displayName = displayName;
    }

    @Override
    public String toString() {
        return displayName;
    }
}
