require 'faraday'

class Quiz

    BASE_URL = "https://4ko7zrz5rs7orwgxcsdphnerrm0gzkwb.lambda-url.us-east-1.on.aws/quiz/"

    attr_reader :username, :type, :questions, :id

    def initialize(username)
        @username = username
        @questions = []
    end

    def setType(type)
        @type = type
    end

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

    def getCorrectQuestions(quizId)
        url = BASE_URL + "getQuiz/#{quizId}"
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

end