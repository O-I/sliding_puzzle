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

      it 'creates a well-formed m x n - 1 puzzle' do
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
      it 'returns an array of the grid tiles
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

    describe '#slide!' do

      context 'with a valid symbol direction' do

        it 'changes the state of the grid' do
          @puzzle.slide!(:left)
          expect(@puzzle.grid).to_not eq [[8, 6, 7], [2, 5, 4], [3, 0, 1]]
        end

        describe ':left' do
          it 'slides a tile one space left' do
            expect(@puzzle.slide!(:left).grid)
              .to eq [[8, 6, 7], [2, 5, 4], [3, 1, 0]]
          end
        end

        describe ':right' do
          it 'slides a tile one space right' do
            expect(@puzzle.slide!(:right).grid)
              .to eq [[8, 6, 7], [2, 5, 4], [0, 3, 1]]
          end
        end

        describe ':up' do
          it 'slides a tile one space up' do
            expect(@puzzle.slide!(:up).grid)
              .to eq [[8, 6, 7], [2, 5, 4], [3, 0, 1]]
          end
        end

        describe ':down' do
          it 'slides a tile one space down' do
            expect(@puzzle.slide!(:down).grid)
              .to eq [[8, 6, 7], [2, 0, 4], [3, 5, 1]]
          end
        end
      end

      context 'with an invalid symbol direction' do

        before { $stdout.stub(:write) }

        it 'returns the puzzle unchanged' do
          expect(@puzzle.slide! :upward_and_on).to eq @puzzle
          expect(@puzzle.slide! :upward_and_on).to be @puzzle
        end
      end
    end

    describe '#slide' do

      context 'with a valid symbol direction' do

        it 'does not change the state of the grid' do
          @puzzle.slide(:left)
          expect(@puzzle.grid).to eq [[8, 6, 7], [2, 5, 4], [3, 0, 1]]
        end

        describe ':left' do
          it 'returns a copy of the grid
          with a tile slid one space left' do
            expect(@puzzle.slide(:left).grid)
              .to eq [[8, 6, 7], [2, 5, 4], [3, 1, 0]]
          end
        end

        describe ':right' do
          it 'returns a copy of the grid
          with a tile slid one space right' do
            expect(@puzzle.slide(:right).grid)
              .to eq [[8, 6, 7], [2, 5, 4], [0, 3, 1]]
          end
        end

        describe ':up' do
          it 'returns a copy of the grid
          with a tile slid one space up' do
            expect(@puzzle.slide(:up).grid)
              .to eq [[8, 6, 7], [2, 5, 4], [3, 0, 1]]
          end
        end

        describe ':down' do
          it 'returns a copy of the grid
          with a tile slid one space down' do
            expect(@puzzle.slide(:down).grid)
              .to eq [[8, 6, 7], [2, 0, 4], [3, 5, 1]]
          end
        end
      end

      context 'with an invalid symbol direction' do

        before { $stdout.stub(:write) }

        it 'returns a copy of the puzzle unchanged' do
          expect(@puzzle.slide :upward_and_on).to eq @puzzle
          expect(@puzzle.slide :upward_and_on).to_not be @puzzle
        end
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
        @insoluble_4x4 = SlidingPuzzle::Grid.new [[ 1,  2,  3,  4],
                                                  [ 5,  6,  7,  8],
                                                  [ 9, 10, 11, 12],
                                                  [13, 15, 14,  0]]

        @insoluble_3x3 = SlidingPuzzle::Grid.new [[1, 4, 6],
                                                  [5, 2, 0],
                                                  [8, 3, 7]]
      end

      it 'returns whether the puzzle has a solution' do
        expect(@puzzle.solvable?).to be true
        expect(@insoluble_4x4.solvable?).to be false
        expect(@insoluble_3x3.solvable?).to be false
      end
    end

    describe '#solve' do

      context 'when the puzzle is aleady solved' do

        before do
          $stdout.stub(:write)
          @solved = SlidingPuzzle::Grid.new [[1, 2, 3],
                                             [4, 5, 6],
                                             [7, 8, 0]]
        end

        it 'returns the original grid' do
          expect(@solved.solve).to eq @solved.grid
        end
      end

      context 'when the puzzle cannot be solved' do

        before do
          $stdout.stub(:write)
          @insoluble = SlidingPuzzle::Grid.new [[ 1,  2,  3,  4],
                                                [ 5,  6,  7,  8],
                                                [ 9, 10, 11, 12],
                                                [13, 15, 14,  0]]
        end

        it 'returns an empty array' do
          expect(@insoluble.solve).to eq []
        end
      end

      context 'when the puzzle can be solved' do

        before do
          @solvable = SlidingPuzzle::Grid.new [[2, 6, 3],
                                               [1, 0, 4],
                                               [7, 8, 5]]
          @solution = @solvable.solve
        end

        it 'returns the solution set' do
          expect(@solution.last.solved?).to be true
          expect(@solution.size).to eq 15
        end
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

    describe '#random_puzzle' do

      context 'with no arguments' do

        before { @puzzle = SlidingPuzzle::Grid.new }

        it 'returns a random 4 x 4 15 puzzle' do
          expect(@puzzle.dimensions).to eq [4, 4]
          expect(@puzzle.tiles.sort).to eq [*0..15]
        end
      end

      context 'given a height and a width' do

        before do
          @puzzle = SlidingPuzzle::Grid.new
          @puzzle.random_puzzle(5, 8)
        end

        it 'returns a random h x w (h * w - 1) puzzle' do
          expect(@puzzle.dimensions).to eq [5, 8]
          expect(@puzzle.tiles.sort).to eq [*0..39]
        end
      end
    end
  end
end