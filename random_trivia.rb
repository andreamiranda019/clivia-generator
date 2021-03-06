require_relative "random_trivia_controller"
require_relative "requester"
require_relative "presenter"

module RandomTrivia
  include Requester
  include Presenter

  def random_trivia
    load_questions
    ask_questions
  end

  def ask_questions
    # ask each question
    @questions.each do |question|
      ask_question(question)
      questions_options(question).each_with_index do |option, index|
        puts "#{index + 1}.#{option}"
      end
      input = gets_answer_to_question

      if @options[input] == question[:correct_answer]
        print_correct_option(@options[input])
        @score += 10
      else
        print_incorrect_option(@options[input], question[:correct_answer])
      end
    end
    will_save?(@score)
    # once the questions end, show user's score and promp to save it
  end

  def load_questions
    # ask the api for a random set of questions
    questions_respons = RandomTriviaController.questions
    @questions = questions_respons[:body][:results]
    # parse_questions
  end

  def questions_options(question)
    options = question[:incorrect_answers] << question[:correct_answer]
    @options = options.shuffle!
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end
end
