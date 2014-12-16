class Api::V1::BenchmarksController < Api::V1::ApiController
  before_filter :validate_secret, only: [:create, :delete, :delete_all]

  def index
    @benchmarks = RubyBenchmark.all
  end

  def show
    @benchmark = RubyBenchmark.find(params[:id])
  end

  def results
    benchmark = RubyBenchmark.includes(:results).find(params[:id])
    @results = benchmark.results
  end

end
