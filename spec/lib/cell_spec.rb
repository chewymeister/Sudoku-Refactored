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
  end

  context 'neighbours' do
    it 'should assign neighbours when given a set of neighbours by grid' do
      assign_neighbours_to(unsolved_cell, 3)

      expect(unsolved_cell.neighbours).to eq ['1','2','3']
    end
  end

  context 'candidates' do
    it 'should eliminate candidates using its neighbours' do
      assign_neighbours_to(unsolved_cell, 3)
      unsolved_cell.eliminate_candidates

      expect(unsolved_cell.candidates).to eq ['4','5','6','7','8','9']
    end
  end

  def assign_neighbours_to(cell, neighbour_count)
    neighbours = []
    1.upto(neighbour_count) { |n| neighbours << neighbour(n) }
    cell.assign(neighbours) 
  end

  def neighbour(number)
    Cell.new(number.to_s)
  end
end

