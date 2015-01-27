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

    query = @benchmark.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI'}, gcc: 'GCC 4.8 -O3') +
      @benchmark.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI', name: '1.8.6' }, gcc: 'GCC 4.8 -O2')


    @results = ResultGraph.new(@benchmark).average_for_version(query)

  end

  def select
    @selected = params[:b] || []

    @grouped_benchmarks = RubyBenchmark.all.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench
      hsh
    end

    benchmarks = RubyBenchmark.includes(:results, :ruby_versions).where(id: @selected)

    @benchmarks = benchmarks.inject({}) do |hsh, bench|
      query = bench.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI'}, gcc: 'GCC 4.8 -O3') +
        bench.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI', name: '1.8.6' }, gcc: 'GCC 4.8 -O2')
      hsh[bench] = ResultGraph.new(bench).average_for_version(query)
      hsh
    end

  end

  def runs
    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    query = @benchmark.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI'}, gcc: 'GCC 4.8 -O3') +
      @benchmark.results.includes(:ruby_version).where(ruby_versions: {implementation: 'MRI', name: '1.8.6' }, gcc: 'GCC 4.8 -O2')

    @results = ResultGraph.new(@benchmark).average_for_version(query)

    respond_to do |format|
      format.js
    end
  end

end
