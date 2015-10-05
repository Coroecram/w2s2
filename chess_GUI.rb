require 'colorize'
require 'io/console'
load './chess_pieces.rb'
load './chess_board.rb'

class Display
  attr_reader :board
  attr_accessor :cursor_position, :selected_position

  def initialize(board)
    @selected_position = nil
    @board = board
    @cursor_position = [5, 4]
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
    new_pos = [(x + dx) , (y + dy)]
    self.cursor_position = new_pos if board.in_bounds?(new_pos)
  end

  def start_game
    draw_board
    while true
      draw_board
      puts selected_position
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

    when "\r"
      if selected_position
        board.make_move(selected_position, cursor_position)
        self.selected_position = nil
      else
        #if board has valid piece at pos
        self.selected_position = cursor_position
      end
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
  end

  def draw_board
    system("clear")
    render
  end

end


if $PROGRAM_NAME == __FILE__
  b = Board.new
  d = Display.new(b)
  d.start_game
end
