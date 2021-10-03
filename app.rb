require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'



class HangpersonApp < Sinatra::Base
  
  set :bind, "0.0.0.0"
  port = ENV["PORT"] || "8080"
  set :port, port

  enable :sessions
  register Sinatra::Flash
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
    @wrong = 0
    
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # initialize the flash 
    flash[:message] = ''
    flash[:wrong_guesses] = ''
    flash[:word_with_guesses] = ''
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!
    @game = HangpersonGame.new(word)
    session[:game] =@game
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
   
    
     #check if it's alreay been guessed 
     if @game.guess(letter) == false
        flash[:message] = "You have already used that letter."
        #check if it's wrong
     elsif @game.wrong_guesses.include? letter
       flash[:message] = "Invalid guess"
     end
    #show the game state
    flash[:wrong_guesses] = @game.wrong_guesses
    flash[:word_with_guesses] = @game.word_with_guesses
     if @game.check_win_or_lose == :win
        redirect '/win'
     elsif @game.check_win_or_lose == :play 
        redirect '/show'
     elsif @game.check_win_or_lose == :lose
        redirect 'lose'
     end
  end
  
  get '/show' do
   
    erb :show 
  end
  
  get '/win' do
    
    erb :win
  end
  
  get '/lose' do
  
    erb :lose 
  end
  
end