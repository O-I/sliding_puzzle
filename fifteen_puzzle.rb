# Algorithms for determining the solvability of sliding 15 puzzle

# Determines solvability of an nxn puzzle
# See this for basic algorithm:
# http://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html

def solvable?(grid)
  state = grid.flatten
  grid_size = grid.size
  state_size = grid_size ** 2
  blanks_row = state.index(0) / grid_size

  inversions = state.map.with_index do |tile, pos|
    state[pos..state_size].count do |t|
      0 < t && t < tile
    end
  end.reduce(:+)

  (grid_size.odd?  && inversions.even?) ||
  ((grid_size.even? && blanks_row.odd?) == inversions.even?)
end

puz = [[12,  1, 10,  2],
       [ 7, 11,  4, 14],
       [ 5,  0,  9, 15],
       [ 8, 13,  6,  3]]

insoluble =
      [[ 1,  2,  3,  4],
       [ 5,  6,  7,  8],
       [ 9, 10, 11, 12],
       [13, 15, 14,  0]]

p solvable?(puz)
p solvable?(insoluble)
