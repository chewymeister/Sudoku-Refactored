class Grid
  ROW_STARTING_POINT = [0, 0, 0, 3, 3, 3, 6, 6, 6]
  STARTING_POINT = [0,3,6] * 3
  attr_reader :cells

  def initialize(puzzle)
    assign_values_to_cells_using(puzzle)
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
    (0..8).inject([]) do |boxes, index|
      boxes << three_columns_containing(index, from_three_rows_containing(index))
    end
  end

  def from_three_rows_containing(index)
    retrieve_rows.slice(ROW_STARTING_POINT[index],3).transpose
  end

  def three_columns_containing(index, rows)
    rows.slice(STARTING_POINT[index],3).transpose.flatten
  end

  def solve
    @cells.each do |cell|
      cell.assign(neighbours_of(cell))
      cell.attempt_solution unless cell.solved?
    end
  end

  def neighbours_of(cell)
    [row_containing(cell), column_containing(cell), box_containing(cell)].flatten
  end

  def row_containing(cell)
    retrieve_rows.select { |row| row.include?(cell) }
  end

  def column_containing(cell)
    retrieve_columns.select { |column| column.include?(cell) }
  end

  def box_containing(cell)
    retrieve_boxes.select { |box| box.include?(cell) }
  end

  def retrieve_sections(number)
    [ retrieve_row(number), retrieve_column(number), retrieve_box(number) ]
  end

  def board_values
    @board.flatten.map(&:value)
  end

  def to_s
    board_values.join
  end

  def attempt_solution
    @board.flatten.each(&:attempt_solution)
  end

  def board_solved?
    unsolved_cells.count == 0
  end

  def unsolved_cells
    @board.flatten.select(&:unsolved?)
  end

  def solve_board!
    single_solution_attempt until board_solved?
  end

  def single_solution_attempt
    assign_neighbours_for_all_sections
    attempt_solution
  end

  def solve_hard_board!
    outstanding_before, looping = 81, false
    while !board_solved? && !looping 
      single_solution_attempt
      outstanding         = @board.flatten.reject(&:unsolved?).count
      looping             = outstanding_before == outstanding
      outstanding_before  = outstanding
    end
    try_harder unless board_solved?
  end

  def single_solution_cycle
    single_solution_attempt
    @outstanding = unsolved_cell_count
  end

  def looping?
    @outstanding == unsolved_cell_count
  end

  def old_try_harder
    guess_cell
    copy = new_grid.solve_hard_board!
    if copy.board_solved?
      steal_solution(copy)
      #break if board_solved? 
    end
  end

  def try_harder
    blank_cell = unsolved_cells.first
    blank_cell.candidates.each do |candidate|
      blank_cell.assume(candidate)
      board_copy = new_grid

      board_copy.solve_hard_board!

      if board_copy.board_solved?
        steal_solution(board_copy)
        break
      end
    end
  end

  def steal_solution(copy)
    @board = copy.board
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
  attr_reader :candidates
  def initialize(value)
    @value = value
    @neighbours = []
    @candidates = ['1','2','3','4','5','6','7','8','9']
  end

  def assign(neighbours)
    @neighbours = neighbours.map(&:value).delete('0')
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

  def unsolved?
    @value == '0' || @value.nil?
  end

  def guess_value!
    #raise @neighbours.uniq.inspect if @candidates.empty?
    if @candidates.empty?
      1
    else
      @value = @candidates.first
    end
  end


  def assume(candidate)
    @value = candidate
  end
end

