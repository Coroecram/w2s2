class ChessPiece

  def initialize(board, position)
    @position = position
    @board = board
  end
end

class Board

  def initialize
    @grid = Array.new(8) { |row| Array.new(8) { |col| ChessPiece.new(self, [row, col]) } }
  end

end

class Display
end
