class ApplicationController < ActionController::Base
  protect_from_forgery
  helper Qbrick::Engine.helpers
end
