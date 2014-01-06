require 'spec_helper'

describe Grid do
  context 'setup' do
    it 'should be instantiated when given an argument that is 81 chars long' do
      expect(Grid.new("209703810410205607875196023306520100100004359047309068000400980924867001050000002")).to_not be_nil
    end
  end
end

