require 'spec_helper'

describe Grid do
  context 'setup' do
    let(:grid) { Grid.new("209703810410205607875196023306520100100004359047309068000400980924867001050000002") }
    
    it 'should be an instance of Grid' do
      expect(grid).to be_a(Grid)
    end

    it 'create a list of cells with values' do
      expect(grid.list_of_cells_with_assigned_values.first.value).to eq "2"
    end
  end
end

