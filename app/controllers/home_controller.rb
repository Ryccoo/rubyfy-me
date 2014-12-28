require 'overall_graph'

class HomeController < ApplicationController
  def index
    @results = OverallGraph.new.compute_all.points
  end
end
