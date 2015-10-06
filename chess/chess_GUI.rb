require 'colorize'
require 'io/console'
load './chess_pieces.rb'
load './chess_board.rb'

class Display
  attr_reader :board
  attr_accessor :cursor_position, :selected_position, :current_team, :flipped

  def initialize(board)
    @selected_position = nil
    @board = board
    @cursor_position = [5, 4]
    @current_team = :white
    @flipped = false
  end

  def render
    background_color = nil
    flipped == true ? render_grid = @board.grid.reverse : render_grid = @board.grid
    render_grid.each do |row|
      background_color = (background_color.nil? ? :light_black : nil)

      flipped == true ? render_row = row.reverse : render_row = row
      render_row.each do |col|
        background_color = (background_color.nil? ? :light_black : nil)
        if col.position == cursor_position

          print col.to_s.colorize(:background => :light_blue)
        elsif col.position == selected_position
          print col.to_s.colorize(:background => :red)
        else
          print col.to_s.colorize(:background => background_color)
        end
      end
      puts
    end
  end

  def inspecting_render
    @board.grid.each do |row|
      print " ".colorize(:background => :light_white)
      row.each do |col|
        puts "#{col.team}, #{col.position}"
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
    while board.any_available_moves?(current_team)
     draw_board
     input = read_char
     handle_input(input)
    end
    if board.in_check?(current_team)
      puts "Checkmate, #{other_team.to_s.capitalize} wins!"
    else
      puts "The game is a draw."
    end
  end

  def swap_players
    draw_board
    board.flip
    current_team == :white ? self.current_team = :black : self.current_team = :white
    unless flipped.nil?
      flipped == false ? self.flipped = true : self.flipped = false
    end
  end

  def other_team
    current_team == :white ? self.current_team = :black : self.current_team = :white
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
        if board.make_move(selected_position, cursor_position)
          draw_board
          sleep 0.7
          swap_players
        end
        self.selected_position = nil
      else
        if board[cursor_position].team == current_team
          self.selected_position = cursor_position
        end
      end
    when "\e"
      abort
    when "\e[A"
      flipped ? move_cursor(:down) : move_cursor(:up)
    when "\e[B"
      flipped ? move_cursor(:up) : move_cursor(:down)
    when "\e[C"
      flipped ? move_cursor(:left) : move_cursor(:right)
    when "\e[D"
      flipped ? move_cursor(:right) : move_cursor(:left)
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
