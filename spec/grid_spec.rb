require_relative 'spec_helper'
require_relative '../lib/grid'

describe SlidingPuzzle::Grid do
  
  context 'Initialization' do

    describe 'with no arguments' do

      before { @fifteen = SlidingPuzzle::Grid.new }

      it 'creates a well-formed 15 puzzle by default' do
        expect(@fifteen.dimensions).to eq [4, 4]
        expect(@fifteen.tiles.sort).to eq [*0..15]
      end
    end

    describe 'with an m x n matrix' do

      before do
        @eight = SlidingPuzzle::Grid.new [[8, 1, 3],
                                          [4, 0, 2],
                                          [7, 6, 5]]

        @rect = SlidingPuzzle::Grid.new [[5, 6, 11,  3],
                                         [1, 9,  8,  2],
                                         [0, 4,  7, 10]]
      end

      it 'creates a well-formed m x n puzzle' do
        expect(@eight.dimensions).to eq [3, 3]
        expect(@eight.tiles.sort).to eq [*0..8]
        expect(@rect.dimensions).to eq [3, 4]
        expect(@rect.tiles.sort).to eq [*0..11]
      end
    end

    describe 'with invalid arguments' do

      before do
        @strike1 = -> { SlidingPuzzle::Grid.new 'THIS_IS_NOT_A_VALID_ARGUMENT' }
        @strike2 = -> { SlidingPuzzle::Grid.new [[1, 2, 3],
                                                 [4, 5, 6],
                                                 [7, 8, 9]] }
        @strike3 = -> { SlidingPuzzle::Grid.new [[0, 1],
                                                 [2, 3, 4],
                                                 [5, 6, 7, 8]] }
      end

      it 'raises an InvalidGridError' do
        expect(@strike1).to raise_error SlidingPuzzle::InvalidGridError
        expect(@strike2).to raise_error SlidingPuzzle::InvalidGridError
        expect(@strike3).to raise_error SlidingPuzzle::InvalidGridError
      end
    end
  end

  context 'Properties' do

    before :each do
      @puzzle = SlidingPuzzle::Grid.new [[8, 6, 7],
                                         [2, 5, 4],
                                         [3, 0, 1]]
    end

    describe '#grid' do
      it 'returns a matrix representing the grid' do
        expect(@puzzle.grid).to eq [[8, 6, 7], [2, 5, 4], [3, 0, 1]]
      end
    end

    describe '#tiles' do
      it 'returns an array of the grid tiles\
      in order from top left to bottom right' do
        expect(@puzzle.tiles).to eq [8, 6, 7, 2, 5, 4, 3, 0, 1]
      end
    end

    describe '#grid_size' do
      it 'returns the size of the grid' do
        expect(@puzzle.grid_size).to eq 9
      end
    end

    describe '#dimensions' do
      it 'returns the [height, width] of the grid' do
        expect(@puzzle.dimensions).to eq [3, 3]
      end
    end

    describe '#height' do
      it 'returns the number of rows in the grid' do
        expect(@puzzle.height).to eq 3
      end
    end

    describe '#width' do
      it 'returns the number of columns in the grid' do
        expect(@puzzle.width).to eq 3
      end
    end

    describe '#solved?' do

      before do
        @solved = SlidingPuzzle::Grid.new [[1, 2, 3],
                                           [4, 5, 6],
                                           [7, 8, 0]]
      end

      it 'returns whether the puzzle is in order' do
        expect(@puzzle.solved?).to be false
        expect(@solved.solved?).to be true
      end
    end

    describe '#solvable?' do

      before do        
        @insoluble = SlidingPuzzle::Grid.new [[ 1,  2,  3,  4],
                                              [ 5,  6,  7,  8],
                                              [ 9, 10, 11, 12],
                                              [13, 15, 14,  0]]
      end

      it 'returns whether the puzzle has a solution' do
        expect(@puzzle.solvable?).to be true
        expect(@insoluble.solvable?).to be false
      end
    end

    describe '#hamming_weight' do
      it 'returns the Hamming weight of the grid' do
        expect(@puzzle.hamming_weight).to eq 7
      end
    end

    describe '#manhattan_distance' do
      it 'returns the Manhattan distance of the grid' do
        expect(@puzzle.manhattan_distance).to eq 21
      end
    end
  end
end