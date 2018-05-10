class GamesController < ApplicationController
  def new
    @letters = []
    i = 0
    while i < 10
    @letters << ("A".."Z").to_a.sample
    i += 1
    end
  @letters
  unless session[:score]
    session[:score] = 0
  end
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    session[:score] += @word.length

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = JSON.parse(RestClient.get(url))

    if check_word?(@word, @grid) == false
      @not_grid = { score: 0, message: "can't be made out of letters:" }
    elsif response['found'] != true
      @not_english = { score: 0, message: "is not an english word" }
    else
      @results = { message: "is a word. Well done." }
    end

  end
end

private

def check_word?(word, grid)
  result = true
  word.upcase.chars.each do |our_char|
    if grid.include?(our_char)
      grid.delete(our_char)
    else
      result = false
    end
  end
  result
end
