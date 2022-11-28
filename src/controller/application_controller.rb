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
    erb :getUsername
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
    erb :chooseTopic
  end

  # Defines 'POST' on '/startQuiz'
  # sets the Quiz instance's type and makes it call on the "Create Quiz" microservice then redirects to '/question'
  post '/startQuiz' do
    @quiz = Quiz.new(session['username'])
    @quiz.setType(params['btnradio'])
    session['id'] = @quiz.get_questions(0)
    session['answeredQuestions'] = 0
    session['no_of_questions'] = @quiz.questions.length
    redirect '/question'
  end

  # Defines 'GET' on '/question'
  # runs question.erb
  get '/question' do
    @quizModel = Quiz.get_quiz_by_id(session['username'],session['id'])
    @answeredQuestions = session['answeredQuestions']
    @progress = (@answeredQuestions + 1) * 100 / session['no_of_questions']
    erb :question
  end

  # Defines 'POST' on '/checkAnswer'
  # Makes Quiz instance call on "Check Answer" microservice and returns response.body
  post '/checkAnswer' do
    puts "hello from post /checkAnswer"
    req = JSON.parse(request.body.read)
    Quiz.checkAnswer(session['id'],
      req['questionId'],
      req['selectedAnswerId'])
  end

  # Defines 'POST' on '/nextQuestion'
  # Updates session values if user has not finished the Quiz redirects to '/question' else redirects to '/results'
  post '/nextQuestion' do
    session['answeredQuestions'] += 1
    if session['answeredQuestions'] < session['no_of_questions']
      redirect '/question'
    else
      redirect '/results'
    end
  end

  # Defines 'GET' on '/results'
  # Makes Quiz instance call on "Finish" microservice then runs results.erb
  get '/results' do
    @quizModel = Quiz.get_quiz_by_id(session['username'],session['id'])
    @quizModel.finish_quiz
    erb :results
  end

  get '/topRank' do
    @top_scorers = Quiz.get_top_rank()
    erb :topRank
  end

end