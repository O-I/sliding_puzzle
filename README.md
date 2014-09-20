# Sliding Puzzle Solver

**The original goal:**

Solving the 15 puzzle optimally using A* search in Ruby

**The current status:**

I have an implementation of A* that uses Manhattan distance as the heuristic. It now solves any 8 puzzle, including the worst case scenario (31 moves to reach the goal state), in at most 2 seconds, or if no solution exists, immediately says so.

Tests with randomly generated 4 x 4 grids still suggest that the current implementation is insufficient for solving the 15 puzzle in a reasonable amount of time.

**Next, I'll try:**

1. adding pair distance to the current heuristic to increase accuracy
2. switching to iterative deepening A* to keep the memory usage from exploding

(still in progress...)