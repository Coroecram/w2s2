require 'colorize'

class ChessPiece
  attr_reader :position

  def initialize(board, position)
    @position = position
    @board = board
  end

  def to_s
    "8 "
  end

end

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { |row| Array.new(8) { |col| ChessPiece.new(self, [row, col]) } }
  end

end

class Display

  def initialize(board)
    @board = board
    @cursor_position = [0, 0]
  end

  def render
    @board.grid.each do |row|
      row.each do |col|
        if col.position == cursor.position
          print col.colorize(:red)
        end
        print col
      end
      puts
    end
  end


end
