require 'spec_helper'

describe Grid do
  let(:easy_grid) do
    puzzle = '209703810410205607875196023306520100100004359047309068000400980924867001050000002'
    Grid.new(puzzle)
  end

  context 'setup' do
    it 'should be an instance of Grid' do
      expect(easy_grid).to be_a(Grid)
    end

    it 'should assign values to new instances of cells' do
      expect(easy_grid.cells.all? { |cell| cell.value }).to be_true
    end

    it 'is initialized with a board ready to be manipulated' do
      # now no setup required
      expect(easy_grid.cells.first.value).to eq '2'
    end
  end

  context 'retrieve rows, columns, and boxes' do
    it 'retrieves a row of cells' do
      expect(easy_grid.retrieve_rows[4].map(&:value)).to eq ['1','0','0','0','0','4','3','5','9']
    end    

    it 'retrieves a column of cells' do
      expect(easy_grid.retrieve_columns[2].map(&:value)).to eq ['9','0','5','6','0','7','0','4','0']
    end

    it 'retrieves a box of cells' do
      expect(easy_grid.retrieve_boxes[7].map(&:value)).to eq ['4','0','0','8','6','7','0','0','0']
    end
  end

  context 'assign neighbours to cells' do
    it 'retrieves the correct neighbours for a cell' do
      cell = easy_grid.cells[20]

      expect(easy_grid.neighbours_of(cell).map(&:value)).to eq ['8','7','5','1','9','6','0','2','3',
                                                                '9','0','5','6','0','7','0','4','0',
                                                                '2','0','9','4','1','0','8','7','5']
    end
  end

  context 'solve the puzzle' do
    it 'tells all cells to attempt solution' do
      board_before_attempt = easy_grid.board_values
      easy_grid.attempt

      expect(easy_grid.board_values).not_to eq board_before_attempt
    end

    it 'checks to see if board has been solved' do
      3.times { easy_grid.attempt }

      expect(easy_grid).to be_solved
    end

    it 'solves an easy board' do
      easy_grid.solve_board!

      expect(easy_grid).to be_solved
    end
  end

  context 'solves a hard puzzle' do
    let(:hard_grid) do
      puzzle = '800000000003600000070090200050007000000045700000100030001000068008500010090000400'
      Grid.new(puzzle)
    end
    
    it 'stops solution attempt when looping' do
      hard_grid.solve_board!
      hard_grid.inspect_board
      expect(hard_grid).to be_solved
    end
  end
end
