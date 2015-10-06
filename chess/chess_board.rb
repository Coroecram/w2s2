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
    grid_copy = self.grid.map { |el| el.dup }.dup
    self.grid.length.times do |idx|
      self.grid.length.times do |idy|
        self[[(idy - 7).abs,(idx - 7).abs]] = grid_copy[idy][idx]
      end
    end
  end


  def clone
    copy = Board.new
    grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        copy[[x, y]] = tile.dup
      end
    end

    copy
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

  def empty?(pos)
    x, y = pos
    self[pos].is_a?(EmptySpace)
  end

  def make_move(start_pos, end_pos)
    piece = self[start_pos]
    piece.make_move(end_pos)
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]
    piece.implement_move(end_pos)
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

  def team_pieces(team)
    pieces = []
    grid.each do |row|
      row.each do |tile|
        pieces << tile if tile.team == team
      end
    end

    pieces
  end

  def opposing_pieces(team)
    team == :white ? team = :black : team = :white

    team_pieces(team)
  end

  def opposing_moves(team)
    all_moves = []
    pieces = opposing_pieces(team)
    pieces.each do |piece|
      all_moves += piece.valid_moves
    end

    all_moves
  end

  def in_check?(team)
    opposing_moves(team).include?(king_position(team))
  end

  def king_position(team)
    grid.each do |row|
      row.each do |tile|
        return tile.position if tile.team == team && tile.is_a?(King)
      end
    end
  end

end
