class Grid
  STARTING_POINTS = [0,3,6] * 3
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

  def retrieve_cells_at_box(number)
    extract_box(number).flatten
  end

  def extract_box(number)
    @board.slice(number - 1,3).transpose.slice(start_point(number),3).transpose
  end
  
  def start_point(number)
    STARTING_POINTS[number - 1]
  end
  
  def assign_all_row_neighbours
    1.upto(9) do |number|
      retrieve_cells_at_row(number).each do |cell|
        cell.receive_neighbours retrieve_cells_at_row(number)
      end
    end
  end

  def assign_all_column_neighbours
    1.upto(9) do |number|
      retrieve_cells_at_column(number).each do |cell|
        cell.receive_neighbours retrieve_cells_at_column(number)
      end
    end
  end

  def assign_all_box_neighbours
    1.upto(9) do |number|
      retrieve_cells_at_box(number).each do |cell|
        cell.receive_neighbours retrieve_cells_at_box(number)
      end
    end
  end
end

class Cell 
  attr_reader :value
  attr_reader :neighbours
  def initialize(value)
    @value = value
    @neighbours = []
  end

  def receive_neighbours(cell_neighbours)
    cell_neighbours.each { |cell| @neighbours << cell.value }
  end
end


















