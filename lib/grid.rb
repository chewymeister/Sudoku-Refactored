class Grid
  ROW_STARTING_POINT = [0, 0, 0, 3, 3, 3, 6, 6, 6]
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
    @board.slice(every_three_rows(number),3).transpose.slice(every_three_columns(number),3).transpose
  end

  def every_three_rows(number)
    ROW_STARTING_POINT[number - 1]
  end
  
  def every_three_columns(number)
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

  def board_values
    @board.flatten.map(&:value)
  end

  def attempt_solution
    @board.flatten.map(&:attempt_solution)
  end

  def inspect_board
    puts "-------------------------------------"
    @board.each do |row|
      row.each do |cell|
        print "| #{cell.value} "
      end
    puts "|\n-------------------------------------"
    end
  end
end

class Cell 
  attr_reader :value
  attr_reader :neighbours
  def initialize(value)
    @value = value
    @neighbours = []
    @candidates = (1..9).to_a
  end

  def receive_neighbours(cell_neighbours)
    cell_neighbours.each { |cell| @neighbours << cell.value }
  end
  
  def attempt_solution
    @candidates -= @neighbours
    @value = @candidates.first if @candidates.count == 1
  end
end











