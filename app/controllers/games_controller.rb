require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    # set up the array of capital letters
    charset = Array('A'..'Z')
    # create an array of 10 letters from the array of all capital letters
    @letters = Array.new(10) { charset.sample }
    # start the timer for the score calc
    @start_time = Time.now
    # raise
  end

  def score
    # re-initialize start_time
    start_time = Time.at(params[:start_time].to_i)
    # get the end time
    end_time = Time.now
    # create a variable "gird" representing the letters array
    grid = params[:letters].split
    attempt = params[:word]
    in_grid = attempt.upcase.chars.all? { |x| grid.count(x) >= attempt.upcase.chars.count(x) }
    le_wagon_api_output = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    if in_grid && le_wagon_api_output['found']
      @result = { score: attempt.size + (100 - (end_time - start_time)), time: (end_time - start_time), message: 'Well done!' }
    elsif le_wagon_api_output['found']
      @result = { score: 0, message: 'the given word is not in the grid', time: (end_time - start_time).round(1) }
    else
      @result = { score: 0, message: "#{attempt} is not an english word!", time: (end_time - start_time).round(1) }
    end
    @result
  end

end
