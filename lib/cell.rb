require 'spec_helper'

class Cell 
  attr_reader :value
  attr_reader :neighbours
  attr_reader :candidates
  def initialize(value)
    @value = value
    @neighbours = []
    @candidates = ['1','2','3','4','5','6','7','8','9']
  end

  def solve_using(neighbours)
    assign(neighbours)
    attempt_solution unless solved?
  end

  def assign(neighbours)
    @neighbours = neighbours.map(&:value)
  end

  def attempt_solution
    eliminate_candidates
    assign_candidate_to_value if one_candidate_left? 
  end

  def eliminate_candidates
    @candidates -= @neighbours
  end

  def assign_candidate_to_value
    @value = @candidates.pop 
  end
  
  def one_candidate_left?
    @candidates.count == 1
  end

  def solved?
    @value != '0'
  end

  def assume(candidate)
    @value = candidate
  end
end
