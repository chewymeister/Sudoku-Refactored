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

  def attempt_solution
    @board.flatten.each(&:attempt_solution)
  end

  def board_solved?
    @board.flatten.select(&:unsolved?).count == 0
  end

  def solve_board!
    prepare_board_then_solve until board_solved?
  end

  def prepare_board_then_solve
    assign_neighbours_for_all_sections
    attempt_solution
  end

  def solve_hard_board!
    outstanding, looping = 81, false
    until board_solved? || outstanding == unsolved_cell_count?
      prepare_board_then_solve
      outstanding = unsolved_cell_count
      if outstanding == unsolved_cell_count
        try_harder
        break
      end
    end
  end

  def unsolved_cell_count?
    @board.flatten.each(&:unsolved?).count
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
    cell_neighbours.each { |cell| @neighbours << cell.value }
  end
  
  def attempt_solution
    eliminate_candidates if unsolved?
    assign_candidate_to_value if one_candidate_left? 
  end

  def eliminate_candidates
    @candidates -= @neighbours.uniq
  end

  def assign_candidate_to_value
    @value = @candidates.pop 
  end
  
  def one_candidate_left?
    @candidates.count == 1
  end

  def unsolved?
    @value == '0'
  end
end











