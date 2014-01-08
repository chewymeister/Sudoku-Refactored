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
      expect(easy_grid.retrieve_cells_at_row(2).first.value).to eq '4'
    end    

    it 'retrieves a column of cells' do
      expect(easy_grid.retrieve_cells_at_column(1).first.value).to eq '2'
    end

    it 'retrieves a box of cells' do
      expect(easy_grid.retrieve_cells_at_box(1).last.value).to eq '5'
    end
  end

  context 'assign neighbours to cells' do
    it 'builds a list of neighbours in the same row' do
      easy_grid.assign_all_row_neighbours

      expect(easy_grid.board[0][0].neighbours).to eq ['2','0','9','7','0','3','8','1','0']
    end

    it 'builds a list of neighbours in the same column' do
      easy_grid.assign_all_column_neighbours

      expect(easy_grid.board[0][0].neighbours).to eq ["2", "4", "8", "3", "1", "0", "0", "9", "0"]
    end
  end
end
