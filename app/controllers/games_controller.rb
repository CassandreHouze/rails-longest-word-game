require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].split('')
    @grid = params[:grid].split(' ')
    game(@word, @grid)
  end

  def game(word, grid)
    @goal = 0
    if included?(word, grid)
      @goal = (english_word?(word) ? @goal = 0 : @goal += 1)
    else
      @goal -= 1
    end
  end

  # CHECK IF LETTERS OF THE WORD ARE IN THE GIVEN GRID
  def included?(word, grid)
    @new_grid = grid
    @result = 0
    word.each do |letter|
      if @new_grid.include?(letter)
        @result += 0
        @new_grid.delete(letter)
      else
        @result += 1
      end
    end
    return true unless @result.positive?
  end

  # CHECK IF THE WORD IS AN ENGLISH WORD
  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word.join}")
    json = JSON.parse(response.read)
    json['found']
  end
end
