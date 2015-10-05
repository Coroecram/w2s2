load './chess_pieces.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { |row| Array.new(8) { |col| EmptySpace.new(self, [row, col]) } }

    self[[7,3]] = Queen.new(self, [3,3], :white)
  end

  def flip
    self.grid = grid.transpose.map(&:reverse).reverse
    grid.each_index do |idx|
      grid.each_index do |idy|
        pos = [idx, idy]
        self[pos].position = [idx, idy]
      end
    end
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, val)
    x, y = pos
    @grid[x][y] = val
    @grid[x][y].position = pos
  end

  def make_move(start_pos, end_pos)
    piece = self[start_pos]
    piece.make_move(end_pos)
  end

  def draw_row
    @grid.each do |row|
      p row
    end
  end

end
