ENV['SINATRA_ENV'] ||= "development"
ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
require 'require_all'

Bundler.require(:default, ENV['SINATRA_ENV'])

require_all 'src'