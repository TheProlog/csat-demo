# encoding: utf-8

# Application-wide Rails controller. Unless adding methods to share across
# other controllers within the app (which all subclass this one), this should
# always ba a three-liner.
class ApplicationController < ActionController::Base
  protect_from_forgery
end
