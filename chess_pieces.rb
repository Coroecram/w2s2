require 'byebug'

class EmptySpace
  attr_accessor :position, :board
  attr_reader :team

  def initialize(board, position)
    @position = position
    @board = board
    @team = nil
  end

  def to_s
    "8 "
  end

end

class ChessPiece < EmptySpace
  attr_accessor

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
      else
        start_object = self.board[position]
        end_object = EmptySpace.new(board, end_pos)
        self.board[position] = end_object
        self.board[end_pos] = start_object
      end
    end
  end

  def valid_move?(end_pos)
    valid_moves.include?(end_pos)
  end

  def enemy?(other_piece)
    team != other_piece.team
  end

  def friendly?(other_piece)
    team == other_piece.team
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

  DIRECTIONS = [[2, 1],
                [1, 2],
                [2, 1],
                [-2, -1],
                [-1, -2],
                [-1, 2],
                [-2, 1],
                [1, -2],
                [1, -2]
                ]

  def to_s
    "N "
  end

  def valid_moves
    possible_moves = []
    DIRECTIONS.each do |dir|
      x, y = position
      dx, dy = dir
      possible_moves << [x + dx, y + dy]
    end
    possible_moves.select { |pos| board.in_bounds?(pos) && !friendly?(board[pos]) }
  end

end

class Queen < ChessPiece

  def to_s
    "Q "
  end

end

class King < ChessPiece

DIRECTIONS = [[1, 0],
              [0, 1],
              [1, 1],
              [0, -1],
              [-1, 0],
              [-1,-1],
              [1, -1],
              [-1, 1]
              ]

  def to_s
    "K "
  end

  def valid_moves
    possible_moves = []
    DIRECTIONS.each do |dir|
      x, y = position
      dx, dy = dir
      possible_moves << [x + dx, y + dy]
    end
    possible_moves.select { |pos| board.in_bounds?(pos) && !friendly?(board[pos]) }
  end

end
