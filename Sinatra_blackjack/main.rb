# This ruby file requires rubygems and the sinatra framework to run (http://www.sinatrarb.com/)

require 'rubygems'
require 'sinatra'

#sessions are built into Sinatra, we use these to store the player information

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_MIN_HIT = 17
INITIAL_POT_AMOUNT = 500


# The helpers here are used within the routes of the game.

helpers do
  def calculate_total(cards) # cards is [["H", "3"], ["D", "J"], ... ]
    arr = cards.map{|element| element[1]}  # This gives us an array of the values only using the Ruby Map function
    total = 0
    arr.each do |a| #this function adds up the total score for the hand
      if a == "A"
        total += 11
      else
        total += a.to_i == 0 ? 10 : a.to_i  # This logic converts the value to an integer, assigning it to be either 10 if the value is 0 (from the Jack, Queen, King) or the number of the card.
      end
    end

    #correct for Aces. Will reduce the value of Aces to 1 from 11 if their value takes you above 21, as per blackjack rules.
    arr.select{|element| element == "A"}.count.times do
      break if total <= BLACKJACK_AMOUNT
      total -= 10
    end
    total #returns the total value as per standard Ruby Practice
  end

  #

  #builds out our card images as needed
  def card_image(card) # ['H', '4']
    suit = case card[0]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'C' then 'clubs'
      when 'S' then 'spades'
    end

    value = card[1]
    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[1]
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end

    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
  end

  #If called this updates the UI (removes the hit/stay buttons) and updates player the pot with the bet value.
  def winner!(msg)
    @play_again = true
    @show_hit_or_stay_buttons = false
    session[:player_pot] = session[:player_pot] + session[:player_bet]
    @success = "<strong>#{session[:player_name]} wins!</strong> #{msg}"
  end

  #If called this updates the UI (removes the hit/stay buttons) and updates player the pot with the bet value.
  def loser!(msg)
    @play_again = true
    @show_hit_or_stay_buttons = false
    session[:player_pot] = session[:player_pot] - session[:player_bet]
    @error = "<strong>#{session[:player_name]} loses.</strong> #{msg}"
  end

  #If called this updates the UI (removes the hit/stay buttons) but leaves the pot value the same
  def tie!(msg)
    @play_again = true
    @show_hit_or_stay_buttons = false
    @success = "<strong>It's a tie!</strong> #{msg}"
  end
end

#required to be true to set them hidden later, used in winner!, loser!, and tie!.
before do
  @show_hit_or_stay_buttons = true
end

#initial home route, detects player in session or pushes over to the new player route.
get '/' do
  if session[:player_name]
    redirect '/game'
  else
    redirect '/new_player'
  end
end

#loads new player erb template (executable ruby, HTML templating engine) and sets default pot amount.
get '/new_player' do
  session[:player_pot] = INITIAL_POT_AMOUNT
  erb :new_player
end

#checks on post to see if user has filled in player_name, if not throws error. If it's present, it passes the player_name into session and sends them to the bet route.
post '/new_player' do
  if params[:player_name].empty?
    @error = "Name is required"
    halt erb(:new_player)
  end

  session[:player_name] = params[:player_name]
  redirect '/bet'
end

#loads bet template, sets player bet to nil so there isn't carry over from previous bets.
get '/bet' do
  session[:player_bet] = nil
  erb :bet
end

post '/bet' do
  if params[:bet_amount].nil? || params[:bet_amount].to_i == 0 #player must bet at least some money. The to_i check would throw an error if it's a string that isn't a number.
    @error = "Must make a bet."
    halt erb(:bet) #show error message
  elsif params[:bet_amount].to_i > session[:player_pot] #player must actually have enough money
    @error = "Bet amount cannot be greater than what you have ($#{session[:player_pot]})"
    halt erb(:bet)
  else #happy path
    session[:player_bet] = params[:bet_amount].to_i #set bet amount, converting the string provided to an integer
    redirect '/game'
  end
end

#start of the game
get '/game' do
  session[:turn] = session[:player_name]

  # create a deck and put it in session
  suits = ['H', 'D', 'C', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(values).shuffle! # [ ['H', '9'], ['C', 'K'] ... ]

  # create both hands (both hands are stored in session, as is the deck) and then deal out the cards using ruby Array functions.
  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop

  erb :game #load game template with the sessions info
end

post '/game/player/hit' do #route post comes from hit button in game
  session[:player_cards] << session[:deck].pop

  player_total = calculate_total(session[:player_cards])
  if player_total == BLACKJACK_AMOUNT
    winner!("#{session[:player_name]} hit blackjack.")
  elsif player_total > BLACKJACK_AMOUNT
    loser!("It looks like #{session[:player_name]} busted at #{player_total}.")
  end

  erb :game
end

post '/game/player/stay' do #route comes from stay button in game
  @success = "#{session[:player_name]} has chosen to stay."
  @show_hit_or_stay_buttons = false
  redirect '/game/dealer'
end

#we only get to this route if the player hasn't hit a blackjack
get '/game/dealer' do
  session[:turn] = "dealer"
  @show_hit_or_stay_buttons = false

  # decision tree
  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == BLACKJACK_AMOUNT
    loser!("Dealer hit blackjack.")
  elsif dealer_total > BLACKJACK_AMOUNT
    winner!("Dealer busted at #{dealer_total}.")
  elsif dealer_total >= DEALER_MIN_HIT #17, 18, 19, 20
    # dealer stays
    redirect '/game/compare'
  else
    # dealer hits
    @show_dealer_hit_button = true
  end

  erb :game
end

post '/game/dealer/hit' do #route comes from dealer hit button
  session[:dealer_cards] << session[:deck].pop
  redirect '/game/dealer'
end

get '/game/compare' do
  @show_hit_or_stay_buttons = false

  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])

  if player_total < dealer_total
    loser!("#{session[:player_name]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}.")
  elsif player_total > dealer_total
    winner!("#{session[:player_name]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}.")
  else
    tie!("Both #{session[:player_name]} and the dealer stayed at #{player_total}.")
  end

  erb :game
end

get '/game_over' do
  erb :game_over
end
