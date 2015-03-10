require 'custom_graphs'

class CustomController < ApplicationController
  def parallelism
    @benchmark = RubyBenchmark.where(benchmark_collection: 'custom', name: 'parallelism').first

    mri_shown = RubyVersion.where(implementation: 'MRI').order('name DESC').first(5)
    query = @benchmark.results.includes(:ruby_version, :ruby_benchmark).where(ruby_versions: {implementation: ['JRuby', 'Rubinius']}) +
      @benchmark.results.includes(:ruby_version, :ruby_benchmark).where(ruby_version_id: mri_shown, gcc: 'GCC 4.8 -O3')

    @results = CustomGraphs.parallelism(query)
  end
end
