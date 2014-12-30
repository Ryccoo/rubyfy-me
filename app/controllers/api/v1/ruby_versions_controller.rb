class Api::V1::RubyVersionsController < Api::V1::ApiController
  before_filter :validate_secret, only: [:create, :delete, :delete_all]

  api :GET, '/ruby_versions', 'List all ruby versions'
  def index
    @versions = RubyVersion.all
  end

  api :GET, '/ruby_versions/:id', 'Show ruby version'
  param :id, :number, :required => true, desc: 'ID of ruby version'
  def show
    @version = RubyVersion.find(params[:id])
  end

  api :GET, '/ruby_versions', 'Show all ruby version results'
  param :id, :number, :required => true, desc: 'ID of ruby version'
  def results
    @results = RubyVersion.includes(:results).find(params[:id]).results
  end

end
