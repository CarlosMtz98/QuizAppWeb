# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01375577 Carlos Martínez
#          A01374561 Paco Murillo
# File: question.rb

# Model class that defines
# any question with :id, :value(the literal question in string) and :options(array of multiple answers with one correct)
class Question

    attr_reader :id, :value, :options

    # Initializes the Question instance with
    # given values
    def initialize(id, value, options)
        @id = id
        @value = value
        @options = options
    end

    # Prints a string representation
    # of the Question object
    def to_s
        puts "Question: #{@id}, #{@value}"
        options.each do |opt|
            puts opt.to_s
        end
    end

end