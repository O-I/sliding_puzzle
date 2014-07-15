require_relative 'spec_helper'
require_relative '../lib/grid'

describe SlidingPuzzle::Grid do
  
  context 'Initialization' do

    before :each do
      @puzzle = SlidingPuzzle::Grid.new
    end

    describe 'with no arguments' do

      it 'creates a well-formed 15 puzzle by default' do
        expect(@puzzle.dimensions).to eq [4, 4]
        expect(@puzzle.tiles.sort).to eq [*0..15]
      end
    end
  end
end