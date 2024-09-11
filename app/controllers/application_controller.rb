class ApplicationController < ActionController::API
  include AuthenticateHelper
  include AuthenticateAdminHelper
end
