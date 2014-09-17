require 'ruby-prof'
require_relative 'lib/grid'

puzzle = SlidingPuzzle::Grid.new [[6,4,3],[1,0,2],[8,5,7]]

result = RubyProf.profile { puzzle.solve }

printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, {})