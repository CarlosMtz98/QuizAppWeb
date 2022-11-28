# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01375577 Carlos Martínez
#          A01374561 Paco Murillo
# File: option.rb

# Model class that defines
# the answers of the questions selected by the user
class Answer
  attr_reader :is_correct, :question_id, :correct_answer

  def initialize(is_correct, correct_answer, question_id)
    @is_correct = is_correct
    @correct_answer = correct_answer
    @question_id = question_id
  end
end