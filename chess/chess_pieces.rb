require 'byebug'
require 'colorize'

class EmptySpace
  attr_accessor :position, :board
  attr_reader :team

  def initialize(board, position)
    @position = position
    @board = board
    @team = nil
  end

  def to_s
    "+ "
  end

  def enemy?(other_piece)
    nil
  end

  def friendly?(other_piece)
    nil
  end

end

class ChessPiece < EmptySpace
  attr_accessor

  def initialize(board, position, team)
    super(board, position)
    @team = team
  end

  def make_move(end_pos)
    if valid_move?(end_pos)
      self. first_move = nil if self.is_a?(Pawn)

      if enemy?(board[end_pos])
        start_object = self.board[position]
        self.board[position] = EmptySpace.new(board, end_pos)
        self.board[end_pos] = start_object
        return true
      else
        start_object = self.board[position]
        end_object = self.board[end_pos]
        self.board[position] = end_object
        self.board[end_pos] = start_object
        return true
      end
    end
    false
  end

  def valid_move?(end_pos)
    valid_moves.include?(end_pos)
  end

  def enemy?(other_piece)
    other_piece.team != nil && team != other_piece.team
  end

  def friendly?(other_piece)
    team == other_piece.team
  end

end

class Pawn < ChessPiece
  attr_accessor :first_move
  OFFENSIVE_MOVES = [[-1, 1],
                      [-1, -1]]

  def initialize(board, position, team)
    super
    @first_move = true
  end

  def to_s
    team == :white ? "\u2659" + " " : "\u265F" + " "
  end

  def valid_moves
    directions = [[-1, 0]]
    directions << [-2, 0] if first_move
    possible_moves = []
    OFFENSIVE_MOVES.each do |move|
      x, y = position
      dx, dy = move
      directions << move if enemy?(board[[x + dx, y + dy]])
    end
    directions.each do |dir|
      x, y = position
      dx, dy = dir
      possible_moves << [x + dx, y + dy]
    end
    possible_moves.select { |pos| board.in_bounds?(pos) && !friendly?(board[pos]) }
  end

end

class SlidingPiece < ChessPiece
  def valid_moves
    queue = []
    directions.each do |dir|
    end
    possible_moves.select { |pos| board.in_bounds?(pos) && !friendly?(board[pos]) }
  end

end

class Rook < SlidingPiece

  DIRECTIONS = [[0, 1],
                [0, -1],
                [1, 0],
                [-1, 0]]

  def to_s
    team == :white ? "\u2656" + " " : "\u265C" + " "
  end



end

class Bishop < SlidingPiece

  def to_s
    team == :white ? "\u2657" + " " : "\u265D" + " "
  end

end

class Queen < SlidingPiece

  def to_s
    team == :white ? "\u2655" + " " : "\u265B" + " "
  end

end

class SteppingPiece < SlidingPiece

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

class Knight < SteppingPiece

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
    team == :white ? "\u2658" + " " : "\u265E" + " "
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

class King < SteppingPiece

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
    team == :white ? "\u2654" + " " : "\u265A" + " "
  end

end
