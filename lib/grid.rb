class Grid
  def initialize puzzle
    @puzzle = puzzle
  end
  def list_of_cells_with_assigned_values
    @puzzle.chars.map { |num| Cell.new(num) }
  end
end

class Cell < Struct.new(:value)
end
