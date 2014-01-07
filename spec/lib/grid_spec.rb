require 'spec_helper'

describe Grid do
  context 'setup' do
    let(:easy_grid) { Grid.new("209703810410205607875196023306520100100004359047309068000400980924867001050000002") }
    
    it 'should be an instance of Grid' do
      expect(easy_grid).to be_a(Grid)
    end

    it 'assigns values to a list of new cells' do
      expect(easy_grid.assign_values_to_cells.first.value).to eq "2"
    end
    
    it 'creates a board of cells with indices' do
      easy_grid.assign_indices_to_board
      expect(easy_grid.board.fetch(1).value).to eq "2"
    end
          
    xit 'retrieves a row of cells' do
      easy_grid.create_board
      expect(easy_grid.retrieve_cells_at_row(1)[0].value).to eq "2"
      expect(easy_grid.retrieve_cells_at_row(2)[0].value).to eq "4"
    end    
  end
end

