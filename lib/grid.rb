class Grid
  ROW_STARTING_POINT = [0, 0, 0, 3, 3, 3, 6, 6, 6]
  STARTING_POINT = [0,3,6] * 3
  attr_reader :cells

  def initialize(puzzle)
    assign_values_to_cells_using(puzzle)
    @rows = retrieve_rows
    @columns = retrieve_columns
    @boxes = retrieve_boxes
  end

  def assign_values_to_cells_using(puzzle)
    @cells = puzzle.chars.map { |num| Cell.new(num) }
  end
  
  def retrieve_rows
    @cells.each_slice(9).to_a
  end

  def retrieve_columns
    retrieve_rows.transpose
  end

  def retrieve_boxes
    (0..8).inject([]) { |boxes, index| boxes << extract_box(index) }
  end

  def extract_box(index)
    three_columns_containing(index, from_three_rows_containing(index))
  end

  def from_three_rows_containing(index)
    retrieve_rows.slice(ROW_STARTING_POINT[index],3).transpose
  end

  def three_columns_containing(index, rows)
    rows.slice(STARTING_POINT[index],3).transpose.flatten
  end

  def attempt
    @cells.each { |cell| cell.attempt_to_solve_using neighbours_of cell }
  end

  def neighbours_of(cell)
    [row_containing(cell), column_containing(cell), box_containing(cell)].flatten
  end

  def row_containing(cell)
    @rows.select { |row| row.include?(cell) }
  end

  def column_containing(cell)
    @columns.select { |column| column.include?(cell) }
  end

  def box_containing(cell)
    @boxes.select { |box| box.include?(cell) }
  end

  def board_values
    @cells.map(&:value)
  end

  def to_s
    board_values.join
  end

  def solved?
    unsolved_cells.count == 0
  end

  def unsolved_cells
    @cells.select { |cell| !cell.solved? }
  end

  def solve_board!
    @outstanding_before = 81 
    while !solved? && !looping? 
      attempt
      @outstanding_before = unsolved_cells.count
    end
    try_harder unless solved?
  end

  def looping?
    @outstanding_before == unsolved_cells.count
  end

  def try_harder
    blank_cell.candidates.each do |candidate|
      blank_cell.assume(candidate)
      board_copy = new_grid

      board_copy.solve_board!

      steal_solution(board_copy) and break if board_copy.solved?
    end
  end

  def blank_cell
    unsolved_cells.first
  end

  def steal_solution(copy)
    @cells = copy.cells
  end

  def new_grid
    self.class.new(self.to_s)
  end

  def guess_cell
    unsolved_cells.first.guess_value!
  end

  def unsolved_cell_count
    @board.flatten.select(&:unsolved?).count
  end

  def inspect_board
    puts "-------------------------------------"
    retrieve_rows.each do |row|
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
  attr_reader :candidates
  def initialize(value)
    @value = value
    @neighbours = []
    @candidates = ['1','2','3','4','5','6','7','8','9']
  end

  def attempt_to_solve_using(neighbours)
    @neighbours = neighbours.map(&:value)
    attempt_solution unless solved?
  end

  def attempt_solution
    eliminate_candidates
    assign_candidate_to_value if one_candidate_left? 
  end

  def eliminate_candidates
    @candidates -= @neighbours
  end

  def assign_candidate_to_value
    @value = @candidates.pop 
  end
  
  def one_candidate_left?
    @candidates.count == 1
  end

  def solved?
    @value != '0'
  end

  def assume(candidate)
    @value = candidate
  end
end
