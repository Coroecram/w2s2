load './chess_pieces.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { |row| Array.new(8) { |col| EmptySpace.new(self, [row, col]) } }

    self[[7,1]] = Knight.new(self, [7,1], :white)
    self[[7,4]] = King.new(self, [7,4], :white)
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

  def in_bounds?(pos)
    x, y = pos
    return false if x > grid.length - 1 || x < 0
    return false if y > grid.length - 1 || y < 0
    true
  end

end
