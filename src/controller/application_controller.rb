# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01375577 Carlos Martínez
#          A01374561 Paco Murillo
# File: application_controller.rb
require 'sinatra'

# This class inherits from the Sinatra::Base to
# allow us to create our own AppController
class ApplicationController < Sinatra::Base


  configure do
    set :views, 'src/views'
    set :public_folder, 'src/public'
    enable :sessions
  end
  configure(:development) { set :session_secret, "8d9282e008bbb5c0850b7ec52474936796325658aa6ffaf29124f88ca7ed61a1" }

  # Defines 'GET' on '/'
  # runs index.erb
  get '/' do
    erb :index
  end

  # Defines 'GET' on '/getUsername'
  # runs getUsername.erb
  get '/getUsername' do
    erb :get_username
  end

  # Defines 'POST' on '/getUsername'
  # creates a new Quiz instance with the username passed redirects to '/chooseTopic'
  post '/getUsername' do
    session['username'] = params['username']
    redirect "/chooseTopic"
  end

  # Defines 'GET' on '/chooseTopic'
  # runs chooseTopic.erb
  get '/chooseTopic' do
    @username = session[:username]
    if @username.nil?
      redirect '/'
    end
    erb :choose_topic
  end

  # Defines 'POST' on '/startQuiz'
  # sets the Quiz instance's type and makes it call on the "Create Quiz" microservice then redirects to '/question'
  post '/startQuiz' do
    @quiz = Quiz.new(session['username'])
    @quiz.set_type(params['btnradio'])
    session['id'] = @quiz.get_questions(0)
    session['answered_questions'] = 0
    session['no_of_questions'] = @quiz.questions.length
    redirect '/question'
  end

  # Defines 'GET' on '/question'
  # runs question.erb
  get '/question' do
    @quiz = Quiz.get_quiz_by_id(session['username'],session['id'])
    @answered_questions = session['answered_questions']
    @progress = (@answered_questions + 1) * 100 / session['no_of_questions']
    erb :question
  end

  # Defines 'POST' on '/checkAnswer'
  # Makes Quiz instance call on "Check Answer" microservice and returns response.body
  post '/checkAnswer' do
    req = JSON.parse(request.body.read)
    Quiz.check_answer(session['id'],
      req['question_id'],
      req['selected_answer_id'])
  end

  # Defines 'POST' on '/nextQuestion'
  # Updates session values if user has not finished the Quiz redirects to '/question' else redirects to '/results'
  post '/nextQuestion' do
    session['answered_questions'] += 1
    if session['answered_questions'] < session['no_of_questions']
      redirect '/question'
    else
      redirect '/results'
    end
  end

  # Defines 'GET' on '/results'
  # Makes Quiz instance call on "Finish" microservice then runs results.erb
  get '/results' do
    @quiz = Quiz.get_quiz_by_id(session['username'],session['id'])
    @quiz.finish_quiz
    erb :results
  end

  get '/topRank' do
    @top_scorers = Quiz.get_top_rank()
    erb :top_rank
  end

end