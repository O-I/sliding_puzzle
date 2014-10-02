# Sliding Puzzle Solver

**The original goal:**

Solving the 15 puzzle optimally in Ruby

**The current status:**

I have an implementation of A* that uses Manhattan distance as the heuristic. It solves any 8 puzzle, including the worst case scenario (31 moves to reach the goal state), in a few seconds, or if no solution exists, immediately says so.

Tests with randomly generated 4 x 4 grids suggest that A* is insufficient for solving the 15 puzzle in a reasonable amount of time. Further research has confirmed that A* is ill-suited for solving random 15 puzzles.

In light of this, I implemented two further optimizations:

1. I used a more accurate heuristic: Manhattan Pair Distance 
2. I switched to iterative deepening A* to keep a manageable memory profile

This has made solving random 15 puzzles more tractable at the expense of increasing the time to solve random 8 puzzles from a few seconds to a few minutes. The added calculation for linear conflict and the fact that IDA* does not remember prior work is detrimental for the small search space of a 3 x 3 grid, but practically essential for 4 x 4 grids and beyond.

Unfortunately, even after all this, solving random 15 puzzles optimally in a reasonable amount of time in Ruby still proves elusive. The next thing I'll try is to generate a disjoint pattern database for the 15 puzzle and use that as an even more accurate heuristic for IDA*.

(still in progress...)

# References

- A nice breakdown of [solving the 8 puzzle with A*](http://www.cs.princeton.edu/courses/archive/spring09/cos226/assignments/8puzzle.html)

- [Solvability of the Tiles Game](http://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html)

- [How to solve the famous 15 sliding-tile puzzle](https://plus.google.com/+JulienDramaix/posts/4vLG9oghrLy)

- [The Fifteen Puzzle - The Algorithm](http://jamie-wong.com/2011/10/16/fifteen-puzzle-algorithm/)

- [Introduction to A*](http://theory.stanford.edu/~amitp/GameProgramming/AStarComparison.html)

- [Faster problem solving in Java with heuristic search](http://www.ibm.com/developerworks/library/j-ai-search/)

- [The Manhattan Pair Distance Heuristic for the 15-Puzzle](http://disi.unitn.it/~montreso/asd/progetti/2007-08/progetto2/The_Manhattan_Pair_Distance_Heuristic_for_the_15-puzzle.pdf)

- [Genetic Algorithms to Solve Sliding Tile 8-Puzzle Problem](http://www.iasj.net/iasj?func=fulltext&aId=58405)

- [Genetic based Algorithm for N - Puzzle Problem](http://www.academia.edu/4112868/Genetic_based_Algorithm_for_N_-_Puzzle_Problem)

- [Depth-First Iterative-Deepening: An Optimal Admissible Tree Search](http://www.cse.sc.edu/~mgv/csce580f09/gradPres/korf_IDAStar_1985.pdf)

- [Finding Optimal Solutions to the Twenty-Four Puzzle](http://courses.cs.washington.edu/courses/csep573/10wi/korf96.pdf)

- [Searching with Pattern Databases](http://heuristicswiki.wikispaces.com/file/view/Searching+with+pattern+database.pdf)

- [Solving the 24 Puzzle with Instance Dependent Pattern Databases](http://www.bgu.ac.il/~felner/2005/sara2.pdf)

- [Learning Heuristic Functions for 24-Puzzle](http://home.iitk.ac.in/~vinitk/cs365/projects/)

- [Disjoint Pattern Database Heuristics](http://www.bgu.ac.il/~felner/2002-2003/naij.ps)

- [Disjoint Pattern Database Heuristics in Slides](http://www.iis.sinica.edu.tw/~tshsu/tcg2012/slides/slide4.pdf)