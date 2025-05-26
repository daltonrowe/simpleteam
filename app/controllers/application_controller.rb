class ApplicationController < ActionController::Base
  include AuthenticationConcern
  include ConfirmationConcern
  include TeamsConcern

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
