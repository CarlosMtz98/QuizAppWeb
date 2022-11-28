# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01375577 Carlos Martínez
#          A01374561 Paco Murillo
# File: option.rb
require 'faraday'

# Model class that defines
# any Quiz with :id, :username(of the User who created the Quiz), :type and :questions
class Quiz

    BASE_URL = "https://4ko7zrz5rs7orwgxcsdphnerrm0gzkwb.lambda-url.us-east-1.on.aws/quiz/"

    attr_reader :username, :type, :questions, :id

    # Initializes the Quiz instance with
    # given values
    def initialize(username)
        @username = username
        @questions = []
    end

    # Sets the Quiz
    # type
    def setType(type)
        @type = type
    end

    # Calls on the "Create Quiz"
    # microservice and returns the :id to the controller
    def getQuestions(noOfQuestions)
        data = {
            username: @username,
            category: @type,
            status: 0
            # quantity: noOfQuestions
        }
        response = Faraday.post(BASE_URL, JSON.dump(data), content_type: 'application/json')
        if response.success?
            body = JSON.parse(response.body)
            puts body
            @questions = []
            @id = body.dig('entity','id')
            questions_data = body.dig('entity','questions')
            questions_data.each do |q|
                options_data = q.dig('options')
                options = []
                options_data.each do |o|
                    options << Option.new(o.dig('id'), o.dig('text'))
                end
                @questions << Question.new(q.dig('id'), q.dig('value'), options)
            end
            @id
        else
            puts "Getting Questions ERROR"
        end
    end

    # Calls on the "Check Answer"
    # microservice and returns the response.body to the controller
    def checkAnswer(quizId, questionNo, answerId)
        url = BASE_URL + "#{quizId}/add-answer"
        data = {
            questionId: @questions[questionNo].id,
            optionId: answerId
        }
        response = Faraday.put(url, JSON.dump(data), content_type: 'application/json')
        puts JSON.parse(response.body)
        if response.success?
            response.body
        else
            puts "checking Answer ERROR"
        end
    end

    # Calls on the "Finish"
    # microservice and returns the response.body to the controller
    def getCorrectQuestions(quizId)
        url = BASE_URL + "#{quizId}/finish"
        response = Faraday.post(url, JSON.dump({}), content_type: 'application/json')
        puts JSON.parse(response.body)
        if response.success?
            response.body
        else
            puts "checking Answer ERROR"
        end
    end

end