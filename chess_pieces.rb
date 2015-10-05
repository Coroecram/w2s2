class ChessPiece
  attr_accessor :position, :board

  def initialize(board, position)
    @position = position
    @board = board
  end

  def to_s
    "8 "
  end

  def make_move(end_pos)
    if valid_move?(end_pos)
      if board[end_pos].is_a?(EmptySpace)
        board[position], board[end_pos] = board[end_pos], board[position]
      else
        board[end_pos] = board[position]
        board[position] = EmptySpace.new(board, end_pos)
      end
        self.position, board[end_pos].position = board[end_pos].position, self.position
    end
  end

  def valid_move?(end_pos)
    true
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

class Rook < ChessPiece

  def to_s
    "R "
  end

end

class Bishop < ChessPiece

  def to_s
    "B "
  end

end

class Knight < ChessPiece

  def to_s
    "K "
  end

end

class Queen < ChessPiece

  def to_s
    "Q "
  end

  # def make_move(end_pos)
  #   # if valid_move?(move)
  # end
  #
  # def valid_move?(pos)
  #
  # end

end

class King < ChessPiece

  def to_s
    "K "
  end

end
