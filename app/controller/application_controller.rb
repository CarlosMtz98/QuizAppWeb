require 'sinatra'

class ApplicationController < Sinatra::Base

  configure do
    set :views, 'app/views'
    set :public_folder, 'public'
    enable :sessions
  end

  configure(:development) { set :session_secret, "8d9282e008bbb5c0850b7ec52474936796325658aa6ffaf29124f88ca7ed61a1" }

  get '/' do
    erb :index
  end

  get '/getUsername' do
    erb :getUsername
  end

  post '/getUsername' do
    session['quizModel'] = Quiz.new(params['username'])
    puts "#{session[:quizModel].username} hello from post /getUsername"
    redirect "/chooseTopic"
  end

  get '/chooseTopic' do
    puts "hello from get /chooseTopic #{session['quizModel'].username}"
    @quizModel = session['quizModel']
    erb :chooseTopic
  end

  post '/startQuiz' do
    @quizModel = session['quizModel']
    @quizModel.setType(params['btnradio'])
    session['id'] = @quizModel.getQuestions(0)
    puts "hello from post /startQuiz #{@quizModel.type}"
    session['answeredQuestions'] = 0
    redirect '/question'
  end

  get '/question' do
    puts "hello from get /question #{session['quizModel'].type}"
    @quizModel = session['quizModel']
    @answeredQuestions = session['answeredQuestions']
    @progress = @answeredQuestions * 100 / @quizModel.questions.length
    erb :question
  end

  post '/checkAnswer' do
    puts "hello from post /checkAnswer"
    req = JSON.parse(request.body.read)
    puts req
    session['quizModel'].checkAnswer(session['id'],
      session['answeredQuestions'],
      req['selectedAnswerId'])
  end

  post '/nextQuestion' do
    session['answeredQuestions'] += 1
    answeredQuestions = session['answeredQuestions']
    @quizModel = session['quizModel']
    noOfQuestions = @quizModel.questions.length
    if answeredQuestions < noOfQuestions
      redirect '/question'
    else
      redirect '/results'
    end
  end

  get '/results' do
    @correctAnswers = 8
    @noOfQuestions = 10
    @answeredQuestions = session['answeredQuestions']-1
    @quizModel = session['quizModel']
    erb :results
  end

end