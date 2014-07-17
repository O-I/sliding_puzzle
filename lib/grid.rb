require_relative './errors'

module SlidingPuzzle
  class Grid

    def initialize(grid = random_15_puzzle)
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

    def tile_count
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
      tiles == [*0..tile_count - 1].rotate(1)
    end

    def solvable?
      (height.odd?  && inversions.even?) ||
      ((height.even? && blank_at_row.odd?) == inversions.even?)
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

    # TO DO: generalized random function
    def random_15_puzzle
      @grid = [*0..15].shuffle.each_slice(4).to_a
    end

    private

    def valid?(grid)
      (grid.transpose rescue false) &&
      ([*0..grid.flatten.size - 1] - grid.flatten).empty?
    end

    def blank_at_row
      tiles.index(0) / height
    end

    def inversions
      tiles.map.with_index do |tile, pos|
        tiles[pos..tile_count - 1].count do |t|
          0 < t && t < tile
        end
      end.reduce(:+)
    end
  end
end