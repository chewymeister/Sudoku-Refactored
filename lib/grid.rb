class Grid
  attr_reader :board
  def initialize puzzle
    @puzzle = puzzle
    @board ||= {}
  end

  def assign_values_to_cells
    @puzzle.chars.map { |num| Cell.new(num) }
  end
  
  def assign_indices_to_board
    assign_values_to_cells.each_with_index { |cell, index| @board[(index + 1)] = cell }
  end

  def retrieve_cells_at_row(index)
  end
end

class Cell < Struct.new(:value)
end
