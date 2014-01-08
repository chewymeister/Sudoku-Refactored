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
      easy_grid.inspect_board
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
    it 'tell all cells to attempt solution' do
      before_attempt = easy_grid.board_values
      easy_grid.assign_neighbours_for_all_sections
      easy_grid.attempt_solution

      expect(easy_grid.board_values).not_to eq before_attempt
    end
  end
end
