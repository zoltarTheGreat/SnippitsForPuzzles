#!/usr/bin/env ruby
 
require_relative "lib/z3"
 
class TrueKnight
  def initialize
    @solver = Z3::Solver.new
    @cell_x = (0...30).map{|i| Z3::Int("x#{i}")}
    @cell_y = (0...30).map{|i| Z3::Int("y#{i}")}
    @cell_n = (0...30).map{|i| Z3::Int("n#{i}")}
  end
 
  def solve!
    (0...30).each do |i|
      @solver.assert @cell_x[i] >= 0
      @solver.assert @cell_x[i] <= 5
      @solver.assert @cell_y[i] >= 0
      @solver.assert @cell_y[i] <= 4
      @solver.assert @cell_n[i] == @cell_x[i] + 6 * @cell_y[i] + 1
    end
    @solver.assert @cell_n[0] == 1
    @solver.assert @cell_n[3] == 18
    @solver.assert @cell_n[6] == 25
    @solver.assert @cell_n[10] == 12
    @solver.assert @cell_n[18] == 20
    @solver.assert @cell_n[27] == 6
    (0...30).each_cons(2) do |a,b|
      dx = @cell_x[a] - @cell_x[b]
      dy = @cell_y[a] - @cell_y[b]
      abs_dx = (dx > 0).ite(dx, -dx)
      abs_dy = (dy > 0).ite(dy, -dy)
      @solver.assert ((abs_dx == 1) & (abs_dy == 2)) | ((abs_dx == 2) & (abs_dy == 1))
    end
    @solver.assert Z3.Distinct(*@cell_n)
 
    puts "Solutions:"
    while @solver.satisfiable?
      model = @solver.model
      s = (1...30).map{|i| model[@cell_n[i]].to_s }.join
      puts "http://www.rankk.org/challenges/the-rising-knight.py?solution=#{s}"
      @solver.assert Z3.Or(*
        @cell_n.map{|n| n != model[n] }
      )
    end
  end
end
 
TrueKnight.new.solve!