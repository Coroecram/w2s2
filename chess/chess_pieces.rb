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
    "   "
  end

  def enemy?(other_piece)
    nil
  end

  def friendly?(other_piece)
    nil
  end

  def empty?
    team == nil
  end

  def dup(board)
    self.class.new(board, position)
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
      # board_clone = board.clone
      # board_clone.move(position, end_pos)
      # board_clone.flip
      # unless board_clone.in_check?(team)
      self.first_move = nil if self.is_a?(Pawn)
      implement_move(end_pos)
      return true
    end
    false
  end

  # def valid_move?(end_pos)
  #   valid_moves.include?(end_pos)
  # end

  def has_valid_moves?
    valid_moves.any? { |move| valid_move?(move) }
  end

  def valid_move?(end_pos)
    return false unless valid_moves.include?(end_pos)
    board_clone = board.clone
    board_clone.move(position, end_pos)
    board_clone.flip
    return false if board_clone.in_check?(team)
    true
  end

  def enemy?(other_piece)
    other_piece.team != nil && team != other_piece.team
  end

  def friendly?(other_piece)
    team == other_piece.team
  end

  def implement_move(end_pos)
    if enemy?(board[end_pos])
      start_object = self.board[position]
      self.board[position] = EmptySpace.new(board, end_pos)
      self.board[end_pos] = start_object
    else
      start_object = self.board[position]
      end_object = self.board[end_pos]
      self.board[position] = end_object
      self.board[end_pos] = start_object
    end
  end

  def dup(new_board)
     self.class.new(new_board, position, team)
  end

end

class Pawn < ChessPiece
  attr_accessor :first_move

  def initialize(board, position, team)
    super
    @first_move = true
  end

  def to_s
    " " + (team == :white ? "\u2659" : "\u265F") + " "
  end

  def valid_moves
    x, y = position
    directions = []
    directions << [-1, 0] if board[[x - 1, y]].team.nil?
    directions << [-2, 0] if first_move
    possible_moves = []
    [[-1, 1], [-1, -1]].each do |move|
      dx, dy = move
      pos = [x + dx, y + dy]
      if board.in_bounds?(pos)
        if enemy?(board[pos])
          possible_moves << pos
        end
      end
    end
    directions.each do |dir|
      x, y = position
      dx, dy = dir
      possible_moves << [x + dx, y + dy]
    end
    possible_moves.select { |pos| board.in_bounds?(pos) && !friendly?(board[pos]) }
  end

  def dup(new_board)
    new_piece = self.class.new(new_board, position, team)
    new_piece.first_move = first_move
    new_piece
  end


end

class SlidingPiece < ChessPiece
  def valid_moves
    all_valid_moves = []
    self.directions.each do |dir|
      queue = [position]
      until queue.empty?
        current_position = queue.shift
        x, y = current_position
        dx, dy = dir
        destination_pos = [x + dx, y + dy]
        if board.in_bounds?(destination_pos)
          destination_tile = board[destination_pos]
          if destination_tile.empty?
            queue << destination_pos #add  destination to queue
            all_valid_moves << destination_pos #add to valid moves
          elsif enemy?(destination_tile)
            all_valid_moves << destination_pos
          end
        end
      end
    end
    all_valid_moves
  end

  def self.horizontal_directions
    [[0, 1],
     [0, -1],
     [1, 0],
    [-1, 0]]
  end

  def self.diagonal_directions
    [[1, 1],
     [-1, -1],
     [1, -1],
    [-1, 1]]
  end
end

class Rook < SlidingPiece

  def to_s
    " " + (team == :white ? "\u2656" : "\u265C") + " "
  end

  def directions
    SlidingPiece.horizontal_directions
  end



end

class Bishop < SlidingPiece

  def to_s
    " " + (team == :white ? "\u2657" : "\u265D") + " "
  end

  def directions
    SlidingPiece.diagonal_directions
  end

end

class Queen < SlidingPiece

  def to_s
    " " + (team == :white ? "\u2655" : "\u265B") + " "
  end

  def directions
    SlidingPiece.horizontal_directions + SlidingPiece.diagonal_directions
  end

end

class SteppingPiece < SlidingPiece

  def valid_moves
    possible_moves = []
    directions.each do |dir|
      x, y = position
      dx, dy = dir
      possible_moves << [x + dx, y + dy]
    end
    possible_moves.select { |pos| board.in_bounds?(pos) && !friendly?(board[pos]) }
  end

  def directions
    []
  end

end

class Knight < SteppingPiece

  def to_s
    " " + (team == :white ? "\u2658" : "\u265E") + " "
  end

  def directions
    [[2, 1],
     [1, 2],
     [2, 1],
     [-2, -1],
     [-1, -2],
     [-1, 2],
     [-2, 1],
     [1, -2],
     [1, -2]]
  end

end

class King < SteppingPiece

  def to_s
    " " + (team == :white ? "\u2654" : "\u265A") + " "
  end

  def directions
    [[1, 0],
    [0, 1],
    [1, 1],
    [0, -1],
    [-1, 0],
    [-1,-1],
    [1, -1],
    [-1, 1]]
  end

end
