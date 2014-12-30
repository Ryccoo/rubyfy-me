class Api::V1::BenchmarksController < Api::V1::ApiController
  before_filter :validate_secret, only: [:create, :delete, :delete_all]

  api :GET, '/benchmarks', 'List all benchmarks'
  def index
    @benchmarks = RubyBenchmark.all
  end

  api :GET, '/benchmarks/:id', 'Show benchmark details'
  param :id, :number, :required => true, desc: 'ID of benchmark'
  def show
    @benchmark = RubyBenchmark.find(params[:id])
  end

  api :GET, '/benchmarks/:id/results', 'Show all benchmark results'
  param :id, :number, :required => true, desc: 'ID of benchmark'
  def results
    benchmark = RubyBenchmark.includes(:results).find(params[:id])
    @results = benchmark.results
  end

end
