#pragma once

#include <cstdint>
#include <array>

constexpr int BOARD_SIZE = 15;
constexpr int PADDED = 25;
enum class Cell : std::uint8_t {EMPTY = 0, P1 = 1, P2 = 2, WALL = 3};

class Board{
    public:
        Board();
        bool place(int row, int col, Cell who);
        bool checkwin(int row, int col) const;
        Cell at(int row, int col) const { return cells_[row*25 + col];}
        
    private:
        std::array<Cell, 625> cells_;
        int countDirection(int r, int c, int dr, int dc, Cell who) const;
};