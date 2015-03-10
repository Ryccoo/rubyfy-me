class Api::V1::ResultsController < Api::V1::ApiController
  before_filter :validate_secret, only: [:create, :delete, :delete_all]
  protect_from_forgery :except => :create

  api :GET, '/results', 'List all results'
  def index
    @results = Result.all
  end

  api :GET, '/results/:id', 'Show result'
  param :id, :number, :required => true, desc: 'ID of result'
  def show
    @result = Result.find(params[:id])
  end

  api :POST, '/results', 'Add results'
  param :secret_token, String, required: true, desc: 'Secret key to gain publish permissions'
  param :executable, String, required: true, desc: 'Executable name'
  param :ruby, String, required: true, desc: 'Ruby version (format like "ruby-2.2.0")'
  param :time, String, required: true, desc: 'Bench result time'
  param :memory, String, required: true, desc: 'Bench result memory used'
  param :total_memory, String, required: true, desc: 'Bench result memory total'
  param :run_at, String, required: true, desc: 'Date and time of run'
  param :gcc_version, String, required: true, desc: 'GCC version (or other compiler name) used to compile ruby'
  def create
    ActiveRecord::Base.transaction do
      # example request
      # set_form_data({secret_token: key, executable: 'binary-trees.rb', name: 'binary-trees', ruby: 'ruby-1.9.2', time: 45.123, run_at: Time.now})
      # TIMEFORMAT='real %3R'; time ( sleep .0128 ) FOR MORE ACCURATE TESTING

      rv = RubyVersion.new
      rv.full_name = params[:ruby]
      rv_d = RubyVersion.where(implementation: rv.implementation, name: rv.name)
      rv_d.any? ? rv = rv_d.first : rv.save # ruby version is stored at rv at this point

      rb = RubyBenchmark.new
      rb.executable = params[:executable]
      rb_d = RubyBenchmark.where(executable: rb.executable)
      rb_d.any? ? rb = rb_d.first : rb
      if rb.new_record?
        rb.get_source if rb.new_record?
        rb.save
      end

      stdout = (params[:stdout] ? params[:stdout] : "").gsub("\\n", "\n")
      stderr = (params[:stderr] ? params[:stderr] : "").gsub("\\n", "\n")

      result = Result.new(
        time: params[:time].to_d.round(4),
        run_at: Time.parse(params[:run_at]),
        gcc: params[:gcc_version],
        memory: params[:memory].to_d.round(4),
        total_memory: params[:total_memory].to_d.round(4),
        stdout: stdout,
        stderr: stderr
      )
      result.ruby_version = rv
      result.ruby_benchmark = rb

      if result.save
        render json: {status: 'OK'}
      else
        render json: {errors: result.errors }, status: :unprocessable_entity
      end
    end
  end
end

