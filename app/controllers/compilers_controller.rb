require 'result_graph'
require 'coderay'

class CompilersController < ApplicationController
  before_action :available_ruby_versions, :shown_ruby

  def index
    redirect_to compiler_path(RubyBenchmark.first)
  end

  def show
    @grouped_benchmarks = RubyBenchmark.not_custom.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench.name
      hsh
    end

    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_version(query_for(@benchmark, shown_ruby), with_compiler_separation: true)
  end

  def select
    load_selected_benchmarks

    @grouped_benchmarks = available_benchmarks.inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench
      hsh
    end

    if @benchmarks_data.count > 0
      @overview = ResultGraph.new().compilers_overview(query_for(@benchmarks_data, @shown_ruby))
      @overview[:omitted] = @benchmarks_data - @overview[:benchmarks_computed]
    end

    @benchmarks = @benchmarks_data.inject({}) do |hsh, bench|
      graph_data = ResultGraph.new(bench).average_for_version(query_for(bench, shown_ruby), with_compiler_separation: true)

      unless graph_data.blank?
        hsh[bench] = graph_data
      end

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

  def query_for(benchmarks, ruby_version)
    query = Result.includes(:ruby_version, :ruby_benchmark)
        .where(ruby_versions: { name: ruby_version, implementation: 'MRI' }, ruby_benchmark: benchmarks )

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

  def available_benchmarks
    b = Result.includes(:ruby_version, :ruby_benchmark)
        .where(ruby_versions: { name: @shown_ruby, implementation: 'MRI' }).collect(&:ruby_benchmark).uniq
    RubyBenchmark.not_custom.where(id: b).order(:name)
  end

end
