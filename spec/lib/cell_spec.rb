require 'spec_helper'

describe Cell do
  let(:solved_cell) { Cell.new('2') }
  let(:unsolved_cell) { Cell.new('0') }

  context 'setup' do
    it 'should be initialized with a value' do
      expect(solved_cell.value).to eq '2'
    end

    it 'should be initialized with a set of candidates' do
      expect(solved_cell.candidates).to eq ['1','2','3','4','5','6','7','8','9']
    end

    it 'should assign neighbours when given a set of neighbours by grid' do
      neighbour_one = Cell.new('1')
      neighbour_two = Cell.new('2')
      neighbour_three = Cell.new('3')
      neighbours = [neighbour_one, neighbour_two, neighbour_three]
      unsolved_cell.assign(neighbours)

      expect(unsolved_cell.neighbours).to eq ['1','2','3']
    end
  end
end
