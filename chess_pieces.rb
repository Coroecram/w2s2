class ChessPiece
  attr_accessor :position

  def initialize(board, position)
    @position = position
    @board = board
  end

  def to_s
    "8 "
  end

  def valid_moves

  end

end

class EmptySpace < ChessPiece

  def to_s
    "|_"
  end

end

class Pawn < ChessPiece

  def to_s
    "P "
  end

end
