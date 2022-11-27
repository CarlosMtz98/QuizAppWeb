require 'sinatra'
class ApplicationController < Sinatra::Base
  configure do
    set :views, 'app/views'
    set :public_folder, 'public'
  end

  get '/' do
    erb :index
  end

  get '/question' do
    "question"
  end
end