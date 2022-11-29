# Final Project: Quiz Application with Microservices
# Date: 28-Nov-2022
# Authors:
#          A01375577 Carlos Martínez
#          A01374561 Paco Murillo
# File: answer.rb

# Model class that defines
# the answers of the questions selected by the user
class Answer

    # This Answer's is correct
    attr_reader :is_correct

    # This Answer's question id
    attr_reader :question_id

    # This Answer's correct answer (only in case this was not the correct answer)
    attr_reader :correct_answer

  # Inits Answer with given
  # params
  def initialize(is_correct, correct_answer, question_id)
    @is_correct = is_correct
    @correct_answer = correct_answer
    @question_id = question_id
  end
end