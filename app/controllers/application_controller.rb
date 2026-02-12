class ApplicationController < ActionController::Base
  include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound do |e|
    redirect_to root_path, alert: e.message
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    redirect_to root_path, alert: e.record.errors.full_messages.to_sentence
  end

  rescue_from ActionController::ParameterMissing do |e|
    redirect_to root_path, alert: e.message
  end
end
