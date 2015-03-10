require 'result_graph'
require 'coderay'


class MriController < ApplicationController

  def index
    # redirect_to mri_path(RubyBenchmark.first)
    query = Result.not_custom.includes(:ruby_version, :ruby_benchmark).where(ruby_versions: {implementation: 'MRI'}, gcc: 'GCC 4.8 -O3') +
      Result.not_custom.includes(:ruby_version, :ruby_benchmark).where(ruby_versions: {implementation: 'MRI', name: '1.8.6' }, gcc: 'GCC 4.8 -O2')
    @results = ResultGraph.new().versions_overview(query)
  end

  def show
    @grouped_benchmarks = RubyBenchmark.not_custom.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench.name
      hsh
    end

    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_version(query_for(@benchmark))
  end

  def select
    @selected = params[:b] || []

    @grouped_benchmarks = RubyBenchmark.not_custom.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench
      hsh
    end

    benchmarks = RubyBenchmark.includes(:results, :ruby_versions).where(id: @selected)

    @benchmarks = benchmarks.inject({}) do |hsh, bench|
      hsh[bench] = ResultGraph.new(bench).average_for_version(query_for(bench))
      hsh
    end
  end

  def runs
    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_version(query_for(@benchmark))

    respond_to do |format|
      format.js { render 'benchmarks/runs' }
    end
  end

  private
  def query_for(benchmark)
    query = benchmark.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI'}, gcc: 'GCC 4.8 -O3') +
      benchmark.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI', name: '1.8.6' }, gcc: 'GCC 4.8 -O2')

    query
  end

end
