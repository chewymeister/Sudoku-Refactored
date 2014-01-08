class Grid
  STARTING_POINTS = [0,3,6] * 3
  attr_reader :board

  def initialize(puzzle)
    @puzzle = puzzle
    create_board
  end

  def assign_values_to_cells
    @puzzle.chars.map { |num| Cell.new(num) }
  end
  
  def create_board
    @board = assign_values_to_cells.each_slice(9).to_a
  end

  def retrieve_row(number)
    @board[number -1]
  end

  def retrieve_column(number)
    @board.map { |row| row[number - 1] }
  end

  def retrieve_box(number)
    extract_box(number).flatten
  end

  def extract_box(number)
    @board.slice(number - 1,3).transpose.slice(start_point(number),3).transpose
  end
  
  def start_point(number)
    STARTING_POINTS[number - 1]
  end
  
  def assign_neighbours_for_all_sections
    1.upto(9) { |number| iterate_through_rows_columns_boxes number }
  end

  def iterate_through_rows_columns_boxes(number)
    retrieve_sections(number).each { |section| assign_neighbours_to_cell section }
  end

  def assign_neighbours_to_cell(neighbours)
    neighbours.each { |cell| cell.receive_neighbours neighbours }
  end

  def retrieve_sections(number)
    [ retrieve_row(number), retrieve_column(number), retrieve_box(number) ]
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











