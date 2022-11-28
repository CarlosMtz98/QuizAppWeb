# The Greeter App
# Date: 07-May-2021
# Author: Ariel Ortiz

require 'sinatra'
require 'models/greeter_factory'

set :bind, '0.0.0.0'
set :port, ENV['PORT']
enable :sessions
set :session_secret, 'SecretString#!$%'

get '/' do
  @languages = GreeterFactory.available_languages
  erb :index
end

post '/' do
  session[:language] = params[:language] || 'English'
  redirect '/greet'
end

get '/greet' do
  @greeter = GreeterFactory.create(session[:language])
  erb :greet
end