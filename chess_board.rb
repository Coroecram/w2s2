load './chess_pieces.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { |row| Array.new(8) { |col| ChessPiece.new(self, [row, col]) } }
  end

  def flip
    self.grid = grid.transpose.map(&:reverse).reverse
    grid.each_index do |idx|
      grid.each_index do |idy|
        self[idx,idy].position = [idx, idy]
      end
    end
  end

  def [](x, y)
    @grid[x][y]
  end

  def []=(x, y, val)
    @grid[x][y] = val
  end

end
