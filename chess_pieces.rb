require 'byebug'

class EmptySpace
  attr_accessor :position, :board

  def initialize(board, position)
    @position = position
    @board = board
  end

  def to_s
    "8 "
  end

end

class ChessPiece < EmptySpace
  attr_accessor :team

  def initialize(board, position, team)
    super(board, position)
    @team = team
  end

  def make_move(end_pos)
    # byebug
    if valid_move?(end_pos)
      if board[end_pos].is_a?(EmptySpace)
        start_object = self.board[position]
        end_object = self.board[end_pos]
        self.board[position] = end_object
        self.board[end_pos] = start_object
        p self.board.grid.first
      else
        start_object = self.board[position]
        end_object = EmptySpace.new(board, end_pos)
        self.board[position] = end_object
        self.board[end_pos] = start_object
      end
    end
  end

  def valid_move?(end_pos)
    true
  end

  def enemy?(other_piece)
    team != other_piece.team
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


  # def valid_move?(pos)
  #
  # end

end

class King < ChessPiece

  def to_s
    "K "
  end

end
