require 'spec_helper'

describe Cell do
  it 'should be initialized with a value' do
    cell = Cell.new('2')

    expect(cell.value).to eq '2'
  end
end
