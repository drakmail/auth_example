# frozen_string_literal: true

class ApplicationController < ActionController::API
  class AuthError < StandardError; end

  before_action :authenticate, :authenticate!
  attr_reader :current_user

  rescue_from AuthError, with: :handle_access_denied
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActiveRecord::RecordNotUnique, with: :handle_not_unique_record
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from PG::ForeignKeyViolation, with: :handle_record_in_usage

  protected

  def handle_access_denied
    render json: { success: false, errors: ["AUTH_REQUIRED"] }, status: 403
  end

  def handle_invalid_record(e)
    errors = e.record.errors.details.reduce([]) do |acc, (field, errors)|
      acc << [field.to_s.upcase, errors[0][:error].to_s.upcase].join("_")
    end

    render json: { success: false, errors: errors }, status: 400
  end

  def handle_not_unique_record
    render json: { success: false, errors: ["NOT_UNIQUE"] }, status: 400
  end

  def handle_record_not_found
    render json: { success: false, errors: ["NOT_FOUND"] }, status: 404
  end

  def handle_record_in_usage
    render json: { success: false, errors: ["NOT_ALLOWED", "IN_USAGE"] }, status: 403
  end

  # Check JWT and set user if exists
  def authenticate
    token = request.headers["Authorization"]&.split(" ")&.last
    # TODO: for production need to change to RSA or any another similar algo :-)
    decoded_token = JWT.decode(token, nil, false)
    @current_user = decoded_token[0]["sub"]
  rescue JWT::DecodeError
    Rails.logger.warn "Unable to decode JWT token"
  end

  # Check that request has authorized user
  def authenticate!
    # just check, that something exists in sub :-)
    raise AuthError.new if current_user.nil?
  end
end
