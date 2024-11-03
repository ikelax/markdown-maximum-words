#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'colorize'
require_relative 'matching'

def quit(message)
  banner = 'Usage: cli.rb FILE_NAME'
  puts <<~HEREDOC
    #{message.bold.red}

    #{banner.cyan}
  HEREDOC
  exit 1
end

def message(matchings)
  offenses = matchings.filter(&:offense?)

  descriptions = offenses.map(&:description).join("\n\n")

  number_of_matchings = "#{matchings.count} matchings".cyan
  number_of_offenses = offenses.count.positive? ? "#{offenses.count} offenses".red : 'no offenses'.green

  <<~HEREDOC
    #{descriptions}

    #{number_of_matchings} detected, #{number_of_offenses} detected
  HEREDOC
end

file_name, *rest = ARGV

quit 'You passed too many arguments!' unless rest.empty?
quit 'You did not pass a file name.' if file_name.nil?
quit 'The file does not exist!' unless File.exist?(file_name)

# /<!-- (?<maximum_length>\d*) -->\R(?<text_block>.*)?(?:\R(?:\s*?\R)?|\z)/

regex = /<!-- Start (?<maximum_words>\d*) -->[\n\r\s]*(?<text_block>.*)?[\n\r\s]*<!-- End -->/
matchings = File.read(file_name)
                .scan(regex)
                .map { |maximum_words, text_block| Matching.new(maximum_words, text_block) }

puts message(matchings)
