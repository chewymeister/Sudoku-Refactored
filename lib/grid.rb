require 'spec_helper'

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
    (0..8).inject([]) { |boxes, number| boxes << extract_box(number) }
  end

  def extract_box(number)
    three_columns_containing(number, from_three_rows_containing(number))
  end

  def from_three_rows_containing(index)
    retrieve_rows.slice(ROW_STARTING_POINT[index],3).transpose
  end

  def three_columns_containing(index, rows)
    rows.slice(STARTING_POINT[index],3).transpose.flatten
  end

  def attempt
    @cells.each { |cell| cell.solve_using neighbours_of cell }
  end

  def neighbours_of(cell)
    [row_holding(cell), column_holding(cell), box_holding(cell)].flatten
  end

  def row_holding(cell)
    @rows.select { |row| row.include?(cell) }
  end

  def column_holding(cell)
    @columns.select { |column| column.include?(cell) }
  end

  def box_holding(cell)
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
    while not solved? and not looping?
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
    self.class.new(to_s)
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
