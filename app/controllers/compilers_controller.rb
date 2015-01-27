require 'result_graph'
require 'coderay'

class CompilersController < ApplicationController

  def index
    redirect_to compiler_path(RubyBenchmark.first)
  end

  def show
    @grouped_benchmarks = RubyBenchmark.all.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench.name
      hsh
    end

    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_version(query_for(@benchmark), with_compiler_separation: true)
    binding.pry
  end

  def select
    @selected = params[:b] || []

    @grouped_benchmarks = RubyBenchmark.all.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench
      hsh
    end

    benchmarks = RubyBenchmark.includes(:results, :ruby_versions).where(id: @selected)

    @benchmarks = benchmarks.inject({}) do |hsh, bench|
      hsh[bench] = ResultGraph.new(bench).average_for_version(query_for(bench), with_compiler_separation: true)

      hsh
    end

  end

  def runs
    @benchmark = RubyBenchmark.includes(:results, :ruby_versions).find_by_name(params[:id])

    @results = ResultGraph.new(@benchmark).average_for_version(query_for(@benchmark), with_compiler_separation: true)

    respond_to do |format|
      format.js { render 'benchmarks/runs' }
    end
  end

  private
  def query_for(benchmark)
    mri_shown = RubyVersion.includes(:results).where(implementation: 'MRI')
      .select { |version| version.results.map(&:gcc).uniq.count > 1 }


    query = benchmark.results.includes(:ruby_version)
        .where(ruby_version_id: mri_shown)

    query
  end

end
