package ar.tamborindeguy.minesweeperapi.model.cell;

public class Cell {

    private boolean mine;
    private CellState state;

    public Cell(){
        this.mine = false;
        this.state = CellState.UNREVEALED;
    }

    private void setState(CellState state) {
        if (!isRevealed()) {
            this.state = state;
        }
    }

    public void flag() {
        if (isFlagged()) {
            setState(CellState.UNREVEALED);
        } else {
            setState(CellState.FLAG);
        }
    }

    public void mark() {
        if (isQuestion()) {
            setState(CellState.UNREVEALED);
        } else {
            setState(CellState.QUESTION);
        }
    }

    public void reveal() {
        setState(CellState.REVEALED);
    }

    public void setMine() {
        this.mine = true;
    }

    public boolean hasMine() {
        return mine;
    }

    public boolean isRevealed() {
        return state == CellState.REVEALED;
    }

    public boolean isFlagged() {
        return state == CellState.FLAG;
    }

    public boolean isQuestion() {
        return state == CellState.QUESTION;
    }

}
