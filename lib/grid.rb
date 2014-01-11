class Grid
  ROW_STARTING_POINT = [0, 0, 0, 3, 3, 3, 6, 6, 6]
  STARTING_POINTS = [0,3,6] * 3
  attr_reader :board

  def initialize(puzzle)
    @outstanding = 81
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
    three_columns_at(number, three_rows_at(number)).flatten
  end

  def three_columns_at(number, three_rows)
    three_rows.slice(every_three_columns(number),3).transpose
  end

  def three_rows_at(number)
    @board.slice(every_three_rows(number),3).transpose
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

  def receive_neighbours(cell_neighbours)
    cell_neighbours.each { |cell| @neighbours << cell.value }.delete('0')
  end
  
  def attempt_solution
  	return if !unsolved?  	
    eliminate_candidates if unsolved?
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











