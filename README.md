# Sliding Puzzle Solver

The original goal:

Solving the 15 puzzle optimally using A* search in Ruby

The current status:

I have an implementation of A* that uses Manhattan distance as the heuristic. Assuming the algorithm is implemented correctly, it is too slow to solve even moderately difficult 8 puzzles, let alone a random 15 puzzle.

It seems to churn indefinitely on most 3x3 test cases that need 16 or more moves to solve (the worst case for an 8 puzzle is 31 moves to reach the goal state). This suggests that the algorithm spends a lot of time, memory, and CPU cycles going down wrong avenues.

I'll try

(1) adding pair distance to the current heuristic to increase accuracy, and
(2) switching to iterative deepening A* to keep the memory usage from exploding.

Hopefully, this will allow solving the worst case 8 puzzles optimally in a reasonable amount of time. Then I can reassess whether my original goal is feasible in Ruby.

(still in progress...)