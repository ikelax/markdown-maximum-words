# frozen_string_literal: true

require 'colorize'

# Commm
class Matching
  attr_reader :text_block, :maximum_words

  def initialize(maximum_words, text_block)
    @maximum_words = maximum_words.to_i
    @text_block = text_block
  end

  def offense?
    text_block.split.size > maximum_words
  end

  def description
    number_of_words = "#{maximum_words} words".bold.red

    "Maximum of #{number_of_words} was exceeded: #{first_few_characters.yellow}"
  end

  private

  def first_few_characters
    "#{text_block[0, 100]}..."
  end
end
