load './chess_pieces.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { |row| Array.new(8) { |col| EmptySpace.new(self, [row, col]) } }
    populate_board(:white)
    flip
    populate_board(:black)
    flip
  end

  def populate_board(color)
    self[[7,0]] = Rook.new(self, [7,0], color)
    self[[7,7]] = Rook.new(self, [7,7], color)
    self[[7,2]] = Bishop.new(self, [7,2], color)
    self[[7,5]] = Bishop.new(self, [7,5], color)
    self[[7,1]] = Knight.new(self, [7,1], color)
    self[[7,6]] = Knight.new(self, [7,6], color)
    self[[7,3]] = Queen.new(self, [7,3], color)
    self[[7,4]] = King.new(self, [7,4], color)
    grid.length.times do |idx|
      self[[6,idx]] = Pawn.new(self, [6,idx], color)
    end
  end

  def flip
    grid_copy = self.grid.map {|col| col.dup}.dup
    self.grid.length.times do |idx|
      self.grid.length.times do |idy|
        self[[(idy - 7).abs,(idx - 7).abs]] = grid_copy[idy][idx]
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
