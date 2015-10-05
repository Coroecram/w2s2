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
  attr_accessor :cursor_position, :selected_position

  def initialize(board)
    @selected_position = nil
    @board = board
    @cursor_position = [0, 0]
  end

  def render
    @board.grid.each do |row|
      row.each do |col|
        if col.position == cursor_position
          print col.to_s.colorize(:red)
        else
          print col
        end
      end
      puts
    end
  end

  def move_cursor(direction)
    moves = {up: [-1, 0], down: [1, 0], left: [0, -1], right: [0, 1]}
    x, y = cursor_position
    dx, dy = moves[direction]
    self.cursor_position = [(x + dx) , (y + dy)]
  end

  def start_game
    while true
      input = read_char
      handle_input(input)
    end
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def handle_input(input)

    case input

    # when "\r"
    #   puts "RETURN"
    # when "\e"
    #   puts "ESCAPE"
    # when "\e[A"
    #   puts "UP ARROW"
    # when "\e[B"
    #   puts "DOWN ARROW"
    # when "\e[C"
    #   puts "RIGHT ARROW"
    # when "\e[D"
    #   puts "LEFT ARROW"
    when "\r"
      if selected_position
        board.make_move(selected_position, current_position)
      else
        selected_position = current_position
    when "\e"
      abort
    when "\e[A"
      move_cursor(:up)
    when "\e[B"
      move_cursor(:down)
    when "\e[C"
      move_cursor(:right)
    when "\e[D"
      move_cursor(:left)

end
