require 'spec_helper'

describe Grid do
    let(:easy_grid) { Grid.new('209703810410205607875196023306520100100004359047309068000400980924867001050000002') }
  context 'setup' do
    it 'should be an instance of Grid' do
      expect(easy_grid).to be_a(Grid)
    end

    it 'assigns values to a list of new cells' do
      expect(easy_grid.assign_values_to_cells.first.value).to eq '2'
    end
    
    it 'creates a board of cells with indices' do
      easy_grid.create_board
      expect(easy_grid.board[0][0].value).to eq '2'
    end

    it 'is initialized with a board ready to be manipulated' do
      # now no setup required
      expect(easy_grid.board[0][0].value).to eq '2'
    end
  end

  context 'retrieve rows, columns, and boxes' do
    it 'retrieves a row of cells' do
      expect(easy_grid.retrieve_row(2).first.value).to eq '4'
    end    

    it 'retrieves a column of cells' do
      expect(easy_grid.retrieve_column(1).first.value).to eq '2'
    end

    it 'retrieves a box of cells' do
      expect(easy_grid.retrieve_box(6).first.value).to eq '1'
    end
  end

  context 'assign neighbours to cells' do
    it 'takes grid section by section and assigns neighbours to cells in the same section' do
      easy_grid.assign_neighbours_for_all_sections

      expect(easy_grid.board[0][0].neighbours).to eq ['2','0','9','7','0','3','8','1','0',
                                                      '2','4','8','3','1','0','0','9','0',
                                                      '2','0','9','4','1','0','8','7','5']
    end
  end

  context 'solve the puzzle' do
    it 'tells all cells to attempt solution' do
      board_before_attempt = easy_grid.board_values
      cycle_through_solution(easy_grid)

      expect(easy_grid.board_values).not_to eq board_before_attempt
    end

    it 'checks to see if board has been solved' do
      easy_grid.solve_board!

      expect(easy_grid).to be_board_solved
    end
  end

  context 'solves a hard puzzle' do
    let(:hard_grid) do Grid.new('800000000003600000070090200050007000000045700000100030001000068008500010090000400')
    end
    
    it 'stops solution attempt when looping' do
      hard_grid.solve_hard_board!
      easy_grid.solve_hard_board!

      #expect(easy_grid).to be_board_solved
      expect(hard_grid).not_to be_board_solved
    end

    it 'tries a guessed solution if looping' do
      hard_grid.single_solution_attempt
      board_before_guess = hard_grid.board_values
      hard_grid.guess_cell

      expect(hard_grid.board_values).not_to eq board_before_guess
    end
  end

  def cycle_through_solution(grid)
    grid.assign_neighbours_for_all_sections
    grid.attempt_solution
  end
end
