# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01375577 Carlos Martínez
#          A01374561 Paco Murillo
# File: option.rb

# Model class that defines
# any option with :id and :text(the literal answer in string)
class Option

    # This Option's id
    attr_reader :id

    # This Option's text
    attr_reader :text

    # Initializes the Option instance with
    # given values
    def initialize(id, text)
        @id = id
        @text = text
    end

    # Returns a string representation
    # of the Option object
    def to_s
        "Option: #{@id}, #{@text}"
    end
end