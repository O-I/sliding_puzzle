require 'algorithms'
require_relative './errors'

module SlidingPuzzle
  class Grid

    def initialize(grid = random_puzzle)
      if valid? grid
        @grid = grid
      else
        raise ::SlidingPuzzle::InvalidGridError
      end
    end

    def grid
      @grid
    end

    def tiles
      @grid.flatten
    end

    def grid_size
      height * width
    end

    def dimensions
      [height, width]
    end

    def height
      @grid.size
    end

    def width
      @grid[0].size
    end

    def solved?
      tiles == [*0...grid_size].rotate(1)
    end

    def solvable?
      (height.odd?  && inversions.even?) ||
      ((height.even? && blank_at_row.odd?) == inversions.even?)
    end

    def solve
      solved? ? solved : solvable? ? solve_it : insoluble
    end

    def hamming_weight
      tiles.map.with_index do |tile, pos|
        tile == 0 || tile == pos + 1 ? 0 : 1
      end.reduce(:+)
    end

    def manhattan_distance
      @grid.map.with_index do |row, r|
        row.map.with_index do |tile, c|
          if tile == 0
            0
          else
            target_row = ((tile - 1) / height) + 1
            target_col = tile % height
            target_col = height if target_col == 0
            (r + 1 - target_row).abs + (c + 1 - target_col).abs
          end
        end
      end.flatten.reduce(:+)
    end

    def random_puzzle(height = 4, width = 4)
      @grid = [*0...height * width].shuffle.each_slice(width).to_a
    end

    private

    def valid?(grid)
      (grid.transpose rescue false) &&
      ([*0...grid.flatten.size] - grid.flatten).empty?
    end

    def blank_at_row
      tiles.index(0) / height
    end

    def inversions
      tiles.map.with_index do |tile, pos|
        tiles[pos...grid_size].count do |t|
          0 < t && t < tile
        end
      end.reduce(:+)
    end

    def solved
      @grid.tap { puts 'This puzzle is already solved.'}
    end

    def insoluble
      [].tap { puts 'This puzzle cannot be solved.'}
    end

    def solve_it
      'This puzzle can be solved'
    end
  end
end