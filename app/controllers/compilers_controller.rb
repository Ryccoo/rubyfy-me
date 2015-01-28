require 'result_graph'
require 'coderay'

class CompilersController < ApplicationController
  before_action :available_ruby_versions, :shown_ruby

  def index
    redirect_to compiler_path(RubyBenchmark.first, ruby: shown_ruby)
  end

  def show
    @grouped_benchmarks = RubyBenchmark.all.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench.name
      hsh
    end

    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_version(query_for(@benchmark, shown_ruby), with_compiler_separation: true)
  end

  def select
    @selected = params[:b] || []

    @grouped_benchmarks = RubyBenchmark.all.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench
      hsh
    end

    benchmarks = RubyBenchmark.includes(:results, :ruby_versions).where(id: @selected)

    @benchmarks = benchmarks.inject({}) do |hsh, bench|
      hsh[bench] = ResultGraph.new(bench).average_for_version(query_for(bench, shown_ruby), with_compiler_separation: true)

      hsh
    end

  end

  def runs
    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_version(query_for(@benchmark, shown_ruby), with_compiler_separation: true)

    respond_to do |format|
      format.js
    end
  end

  private
  def query_for(benchmark, ruby_version)
    query = benchmark.results.includes(:ruby_version)
        .where(ruby_versions: { name: ruby_version, implementation: 'MRI' } )

    query
  end

  def available_ruby_versions
    @available_rubies = RubyVersion.includes(:results).where(implementation: 'MRI')
    .select { |version| version.results.map(&:gcc).uniq.count > 1 }
  end

  def shown_ruby
    @shown_ruby = params[:ruby] || available_ruby_versions.collect(&:name).sort.last

    @shown_ruby
  end

end
