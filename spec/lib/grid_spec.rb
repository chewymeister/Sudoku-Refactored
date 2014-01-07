require 'spec_helper'

describe Grid do
    let(:easy_grid) { Grid.new("209703810410205607875196023306520100100004359047309068000400980924867001050000002") }
  context 'setup' do
    
    it 'should be an instance of Grid' do
      expect(easy_grid).to be_a(Grid)
    end

    it 'assigns values to a list of new cells' do
      expect(easy_grid.assign_values_to_cells.first.value).to eq "2"
    end
    
    it 'creates a board of cells with indices' do
      easy_grid.create_board
      expect(easy_grid.board[0][0].value).to eq "2"
    end

    it 'is initialized with a board ready to be manipulated' do
      # no setup required
      expect(easy_grid.board[0][0].value).to eq "2"
    end
  end

  context 'retrieve rows, columns, and boxes' do
    it 'retrieves a row of cells' do
      expect(easy_grid.retrieve_cells_at_row(2).first.value).to eq "4"
      expect(easy_grid.retrieve_cells_at_row(1).count).to eq 9
    end    

    it 'retrieves a column of cells' do
      expect(easy_grid.retrieve_cells_at_column(1).first.value).to eq "2"
    end
  end

end

