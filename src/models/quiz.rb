# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01375577 Carlos Martínez
#          A01374561 Paco Murillo
# File: quiz.rb
require 'faraday'

# Model class that defines
# any Quiz with :id, :username(of the User who created the Quiz), :type and :questions
class Quiz

    # Microservices base url
    BASE_URL = "https://4ko7zrz5rs7orwgxcsdphnerrm0gzkwb.lambda-url.us-east-1.on.aws/quiz/"

    # This Quiz's creator username
    attr_accessor :username

    # This Quiz's type
    attr_accessor :type

    # This Quiz's questions
    attr_accessor :questions

    # This Quiz's id
    attr_accessor :id

    # This Quiz's number of correct answers
    attr_accessor :correct_answers

    # This Quiz's number of wrong answers
    attr_accessor :wrong_answer

    # This Quiz's answers
    attr_accessor :answers

    # This Quiz's grade
    attr_accessor :grade

    # Initializes the Quiz instance with
    # given values
    def initialize(username)
        @username = username
        @questions = []
        @answers = []
    end

    # Sets the Quiz
    # type
    def set_type(type)
        @type = type
    end

    # Calls on the "Create Quiz"
    # microservice and returns the :id to the controller
    def get_questions(noOfQuestions)
        data = {
            userName: @username,
            category: @type,
            status: 0
            # quantity: noOfQuestions
        }
        response = Faraday.post(BASE_URL, JSON.dump(data), content_type: 'application/json')
        if response.success?
            parse_quiz_response(response)
            @id
        else
            puts "Getting Questions ERROR"
        end
    end

    # Calls on the "Finish"
    # microservice and returns the response.body to the controller
    def finish_quiz
        url = BASE_URL + "#{@id}/finish"
        response = Faraday.post(url, JSON.dump({}), content_type: 'application/json')
        if response.success?
            parse_quiz_response(response)
        else
            puts "checking Answer ERROR"
        end
    end

    # Calls on the "Check Answer"
    # microservice and returns the response.body to the controller
    def self.check_answer(quizId, question_id, answerId)
        url = BASE_URL + "#{quizId}/add-answer"
        data = {
            questionId: question_id,
            optionId: answerId
        }
        response = Faraday.put(url, JSON.dump(data), content_type: 'application/json')
        if response.success?
            response.body
        else
            puts "checking Answer ERROR"
        end
    end

    # Gets top scores
    # from microservice
    def self.get_top_rank
        url = BASE_URL + "top-scores"
        response = Faraday.get(url)
        if response.success?
            JSON.parse(response.body)
        else
            puts "getting Top Rank ERROR"
        end
    end

    # Get Quiz by
    # id from microservice
    def self.get_quiz_by_id(username,id)
        url = BASE_URL + "#{id}"
        response = Faraday.get(url)
        if response.success?
            Quiz.parse_quiz_instance_from_response(response)
        else
            puts "getting Top Rank ERROR"
        end
    end

    # Creates Quiz instance from microservice
    # reesponse
    def self.parse_quiz_instance_from_response(response)
        body = JSON.parse(response.body)
        quiz = Quiz.new(body.dig('entity','userName'))
        quiz.questions = []
        quiz.id = body.dig('entity', 'id')
        questions_data = body.dig('entity', 'questions')
        questions_data.each do |q|
            options_data = q.dig('options')
            options = []
            options_data.each do |o|
                options << Option.new(o.dig('id'), o.dig('text'))
            end
            quiz.questions << Question.new(q.dig('id'), q.dig('value'), options)
        end
        quiz.grade = body.dig('entity', 'grade')
        answers = body.dig('entity', 'answers')
        unless answers.nil?
            Quiz.parse_quiz_instance_answer(quiz,answers)
        end
        quiz
    end

    # Sets quiz
    # answers
    def self.parse_quiz_instance_answer(quiz,answers)
        quiz.answers = []
        quiz.correct_answers = 0
        quiz.wrong_answer = 0
        answers.each do |ans|
            is_correct = ans.dig('isCorrect')
            correct_answer = ans.dig('correctAnswer')
            question_id = ans.dig('questionId')
            if is_correct
                quiz.correct_answers += 1
            else
                quiz.wrong_answer += 1
            end
            answer = Answer.new(is_correct, correct_answer, question_id)
            quiz.answers << answer
        end
    end

    private

    # Parses the response
    # from the microservice
    def parse_quiz_response(response)
        body = JSON.parse(response.body)
        @questions = []
        @id = body.dig('entity', 'id')
        questions_data = body.dig('entity', 'questions')
        questions_data.each do |q|
            options_data = q.dig('options')
            options = []
            options_data.each do |o|
                options << Option.new(o.dig('id'), o.dig('text'))
            end
            @questions << Question.new(q.dig('id'), q.dig('value'), options)
        end
        @grade = body.dig('entity', 'grade')
        answers = body.dig('entity', 'answers')
        unless answers.nil?
            parse_quiz_answer(answers)
        end
    end

    # Parse the
    # answers object
    def parse_quiz_answer(answers)
        @answers = []
        @correct_answers = 0
        @wrong_answer = 0
        answers.each do |ans|
            is_correct = ans.dig('isCorrect')
            correct_answer = ans.dig('correctAnswer')
            question_id = ans.dig('questionId')
            if is_correct
                @correct_answers += 1
            else
                @wrong_answer += 1
            end
            answer = Answer.new(is_correct, correct_answer, question_id)
            @answers << answer
        end
    end
end