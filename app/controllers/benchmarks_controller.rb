require 'result_graph'
require 'coderay'

class BenchmarksController < ApplicationController

  def index
    redirect_to benchmark_path(RubyBenchmark.first)
  end

  def show
    @grouped_benchmarks = RubyBenchmark.all.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench.name
      hsh
    end

    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_gcc_n_version

  end

  def select
    @selected = params[:b] || []

    @grouped_benchmarks = RubyBenchmark.all.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench
      hsh
    end

    benchmarks = RubyBenchmark.includes(:results, :ruby_versions).where(id: @selected)

    @benchmarks = benchmarks.inject({}) do |hsh, bench|
      hsh[bench] = ResultGraph.new(bench).average_for_gcc_n_version
      hsh
    end

  end

  def runs
    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_gcc_n_version

    respond_to do |format|
      format.js
    end
  end

end
