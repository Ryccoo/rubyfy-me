class BenchmarksController < ApplicationController

  def index
    @benchmarks = RubyBenchmark.all.order(:name)

    @selected = @benchmarks.first
    render :show
  end

  def show

  end
end
