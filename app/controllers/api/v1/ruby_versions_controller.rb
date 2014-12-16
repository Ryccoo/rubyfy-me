class Api::V1::RubyVersionsController < Api::V1::ApiController
  before_filter :validate_secret, only: [:create, :delete, :delete_all]

  def index
    @versions = RubyVersion.all
  end

  def show
    @version = RubyVersion.find(params[:id])
  end

  def results
    @results = RubyVersion.includes(:results).find(params[:id]).results
  end

end
