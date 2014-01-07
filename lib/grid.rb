class Grid
  attr_reader :board
  def initialize puzzle
    @puzzle = puzzle
    create_board
  end

  def assign_values_to_cells
    @puzzle.chars.map { |num| Cell.new(num) }
  end
  
  def create_board
    @board = assign_values_to_cells.each_slice(9).to_a
  end

  def retrieve_cells_at_row(number)
    @board[number -1]
  end

  def retrieve_cells_at_column(number)
    @board.map {|row| row[number - 1]}
  end
end

class Cell < Struct.new(:value)
end
