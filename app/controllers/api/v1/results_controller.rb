class Api::V1::ResultsController < Api::V1::ApiController
  before_filter :validate_secret, only: [:create, :delete, :delete_all]

  def index
    @results = Result.all
  end

  def show
    @result = Result.find(params[:id])
  end
end
