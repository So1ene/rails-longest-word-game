require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(12)
  end

  def score
    @letters = params[:letters].split
    @attempt = params[:attempt]
    if english_word?(@attempt)
      @english = '✅ English word'
    else
      @english = '❌ Not an english word'
    end
    if included?(@attempt, @letters)
      @included = '✅ Includes correct letters'
    else
      @included = '❌ Does not include correct letters'
    end
    if @english.start_with?("✅") && @included.start_with?("✅")
      @score = "You win!"
    else
      @score = "You lose!"
    end
  end

  def generate_grid(grid_size = 12)
    @letters = []
    (grid_size - 3).times do
      @letters << ('A'..'Z').to_a.sample
    end
    3.times do
      @letters << %w[A E I O U].sample
    end
    @letters
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(attempt, letters)
    attempt.upcase.chars.all? { |letter| letters.count(letter) >= attempt.count(letter) }
  end
end
