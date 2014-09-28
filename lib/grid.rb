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

    def to_s
      padding = String(grid_size - 1).size + 1
      @grid.each do |row|
        row.each do |tile|
          print String(tile).rjust(padding)
        end
        puts
      end
    end

    def ==(obj)
      obj.class == self.class && obj.grid == self.grid
    end

    alias_method :eql?, :==

    def slide!(direction)
      r, c = blank_at_row, blank_at_column
      self.tap do
        case direction
        when :left  then swap r, c + 1 unless c == width - 1
        when :right then swap r, c - 1 unless c == 0
        when :up    then swap r + 1, c unless r == height - 1
        when :down  then swap r - 1, c unless r == 0
        else puts 'Valid input for slide: :up, :down, :left, :right'
        end
      end
    end

    def slide(direction)
      copy = Marshal.load(Marshal.dump(self))
      copy.slide!(direction)
    end

    def solved?
      tiles == [*0...grid_size].rotate(1)
    end

    def solvable?
      (height.odd?  &&  inversions.even?) ||
      (height.even? && (inversions.even?  == blank_at_row.odd?))
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

    def linear_conflict
      pairs = 0
      goal = [*0...grid_size].rotate(1).each_slice(width).to_a

      for_rows = [grid, goal]
      for_columns = for_rows.map(&:transpose)

      pair_distance(*for_rows) + pair_distance(*for_columns)
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

    def blank_at_column
      tiles.index(0) % width
    end

    def swap(x, y)
      r, c = blank_at_row, blank_at_column
      @grid[r][c], @grid[x][y] = @grid[x][y], @grid[r][c]
    end

    def inversions
      tiles.map.with_index do |tile, pos|
        tiles[pos...grid_size].count do |t|
          0 < t && t < tile
        end
      end.reduce(:+)
    end

    def pair_distance(grid, goal)
      pairs = 0
      grid.map.with_index { |row, i| row & goal[i] }
          .select { |r| r.size > 1 }
          .each do |line|
            while tile = line.shift
              if pair = line.find { |t| tile > t }
                pairs += 2
                line.delete pair
              end
            end
          end
      pairs
    end

    def solved
      @grid.tap { puts 'This puzzle is already solved.'}
    end

    def insoluble
      [].tap { puts 'This puzzle cannot be solved.'}
    end

    def solve_it
      by_min_value = -> x, y { x <= y }
      q = Containers::PriorityQueue.new &by_min_value

      state = [[], self, 0]
      priority = manhattan_distance + linear_conflict
      directions = [:up, :down, :left, :right]

      q.push(state, priority)

      until q.empty?
        steps_taken, currently_at, cost = q.pop
        journey = [steps_taken, currently_at]

        return journey.flatten if currently_at.solved?

        directions
          .map { |way| currently_at.slide(way) }
          .tap { cost += 1 }
          .reject { |g| g == currently_at || g == steps_taken.flatten.last }
          .each do |next_step|
            state = [journey, next_step, cost]
            priority = cost + next_step.manhattan_distance + next_step.linear_conflict
            q.push(state, priority)
          end
      end
    end
  end
end