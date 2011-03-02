require 'rubygems'
require 'test/unit'
require 'shoulda'

class Board
  attr_reader :board

  def initialize(length_of_side=10)
    pass_count = 0
    @board = []
    unless live_count > (length_of_side*length_of_side/3) || pass_count > 5
      pass_count += 1
      @board = initialize_row(length_of_side)
      @board.map! {initialize_row(length_of_side)}
      puts "Initialized a #{length_of_side}x#{length_of_side} board with #{live_count} live cells"
    end
  end
  
  def live_count
    sum = @board.flatten.inject(0) {|sum, cell| sum + cell}
  end
  
  def initialize_row(size=10)
    row = Array.new(size)
    row.fill {|e| rand(2)}
  end

end

class GolTest < Test::Unit::TestCase
  def print_board(board)
    board.map do |row|
      row.join(' ')
    end.join("\n")
  end
  def generation(board)
    new_board = board.map{[]}
    board.each_with_index do |row,y|
      row.each_with_index do |col,x|
        new_board[y][x]= determine_life_or_death_of(col, neighbors_for(board,x,y))
      end
    end
    new_board
  end
  
  def determine_life_or_death_of(cell, neighbors)
    sum = neighbors.inject(0) {|sum, neighbor| neighbor + sum}
    (if cell.zero?
      sum == 3
    else
      [2,3].include?(sum)
    end) ? 1 : 0
  end

  def value_in_grid(grid, x, y, x_change, y_change)
    ulx = x + x_change
    uly = y + y_change
    
    if ulx < 0 || ulx >= grid.size || uly < 0 || uly >= grid.size
      0
    else
      grid[uly][ulx]
    end
  end

  def upper_left(grid, x, y)
    value_in_grid(grid, x, y, -1, -1)
  end
  
  def upper(grid, x, y)
    value_in_grid(grid, x, y, 0, -1)
  end
  
  def upper_right(grid, x, y)
    value_in_grid(grid, x, y, 1, -1)
  end
  
  def right(grid, x, y)
    value_in_grid(grid, x, y, 1, 0)
  end
  
  def lower_right(grid, x, y)
    value_in_grid(grid, x, y, 1, 1)
  end
  
  def lower(grid, x, y)
    value_in_grid(grid, x, y, 0, 1)
  end
  
  def lower_left(grid, x, y)
    value_in_grid(grid, x, y, -1, 1)
  end
  
  def left(grid, x, y)
    value_in_grid(grid, x, y, -1, 0)
  end
  
  def neighbors_for(grid, x, y)
    [
      upper_left(grid, x, y),
      upper(grid, x, y),
      upper_right(grid, x, y),
      right(grid, x, y),
      lower_right(grid, x, y),
      lower(grid, x, y),
      lower_left(grid, x, y),
      left(grid, x, y)
    ]
  end
  
  context "a dead cell" do
    setup do
      @cell = 0
    end
    context "with 3 living neighbors" do
      setup do
        @neighbors =  [1,1,1,0,0,0,0,0]
      end
      should "result in a living cell" do
        assert_equal 1, determine_life_or_death_of(@cell, @neighbors)
      end
    end
    # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    context "with 1 living neighbors" do
      setup do
        @neighbors =  [1,0,0,0,0,0,0,0]
      end
      should "result in a dead cell" do
        assert_equal 0, determine_life_or_death_of(@cell, @neighbors)
      end
    end
  end

  context "a live cell" do
    setup do
      @cell = 1
    end
    context "with 2 living neighbors" do
      setup do
        @neighbors =  [1,1,0,0,0,0,0,0]
      end
      should "result in a live cell" do
        assert_equal 1, determine_life_or_death_of(@cell, @neighbors)
      end
    end
  end
  
  context "an all-dead board" do
    setup do
      @board = [
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0],
        [0,0,0,0]
        ]
    end
    should "return neighbors given coordinates" do
      assert_equal [0,0,0,0,0,0,0,0], neighbors_for(@board, 1, 1)
    end
    
    should "result in a new all dead board on generation" do
      assert_equal @board, generation(@board)
    end
  end
  context "a partially alive board" do
    setup do
      @board = [
        [1, 1, 1, 0],
        [1, 1, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
        ]
    end
    should "return neighbors given coordinates" do
      assert_equal [1,1,1,0,0,0,0,1], neighbors_for(@board, 1, 1)
    end
    should "result in expected board on generation" do
      expected = [
        [1, 0, 1, 0],
        [1, 0, 1, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
        ]
      assert_equal expected, generation(@board)
    end    
  end
  
  def print_board_fancy(board)
    STDERR.print "\e[2J\e[f" # Magic to clear screen (possibly works only in *nix)
    h_border ="\n|" + "--"*(board[0].size) + "|\n"
    text = h_border
    text += board.map do |row|
      "|" + row.collect {|x| x == 1 ? "#" : " "}.join(' ') + " |"
    end.join("\n")
    text += h_border
    text
  end
  
  context "a partially alive board" do
    setup do
      @board = [
        [1, 1, 1, 0, 1, 1, 1, 0],
        [1, 1, 0, 0, 1, 1, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [1, 1, 0, 0, 1, 1, 0, 0],
        [1, 1, 1, 0, 1, 1, 1, 0]
        ]
        
        @board = Board.new(50).board
    end
    should "simulate for a while" do
      loop do
        STDERR.puts print_board_fancy(@board)
        new_board = generation(@board)
        break if new_board == @board
        @board = new_board
        # sleep 0.1
      end
    end    
  end
end