class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def load_selected_benchmarks
    @selected = params[:b] || []
    @groups = params[:bg] || []

    @grouped_benchmarks = RubyBenchmark.not_custom.order(:name).inject({}) do |hsh, bench|
      (hsh[bench.benchmark_collection] ||= []) << bench
      hsh
    end

    @benchmarks_data = RubyBenchmark.includes(:results, :ruby_versions).where(id: @selected)
    @benchmarks_data += RubyBenchmark.includes(:results, :ruby_versions).where(benchmark_collection: @groups)
    @benchmarks_data.uniq!
  end
end
