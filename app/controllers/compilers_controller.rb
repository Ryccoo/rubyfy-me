require 'result_graph'
require 'coderay'

class CompilersController < ApplicationController
  before_action :available_ruby_versions, :shown_ruby

  def index
    # redirect_to compiler_path(RubyBenchmark.first, ruby: shown_ruby)
    ruby = RubyVersion.where(name: shown_ruby, implementation: 'MRI' ).first
    query = Result.includes(:ruby_version, :ruby_benchmark).where(ruby_version_id: ruby)
    @results = ResultGraph.new().compilers_overview(query)
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

    ruby = RubyVersion.includes(:ruby_benchmarks).where(implementation: 'MRI', name: shown_ruby).first

    @grouped_benchmarks = available_benchmarks(ruby).inject({}) do |hsh, bench|
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
    @available_rubies ||= RubyVersion.includes(:results, :ruby_benchmarks).where(implementation: 'MRI')
    .select { |version| version.results.map(&:gcc).uniq.count > 1 }

    @available_rubies
  end

  def shown_ruby
    @shown_ruby = params[:ruby] || available_ruby_versions.collect(&:name).sort.last

    @shown_ruby
  end

  def available_benchmarks(ruby)
    ruby.ruby_benchmarks.uniq.sort_by(&:name)
  end

end
