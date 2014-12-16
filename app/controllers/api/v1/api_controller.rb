class Api::V1::ApiController < ApplicationController
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound do
    render json: {error: 'Record not found'}, status: :not_found
  end

  def validate_secret
    unless ENV['BENCH_SECRET'] == params[:secret_token]
      render json: {error: 'Unauthorized'}, status: :unauthorized
    end
  end
end
