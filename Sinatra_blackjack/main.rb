require 'rubygems'
require 'sinatra'

set :sessions, true

helpers do
  def calculate_total(cards)
    arr = cards.map{|element| element[1]}
    
    total = 0
    arr.each do |a|
      if a == "Ace"
        total += 11
      else
        total += a.to_i == 0 ? 10 : a.to_i
      end
     end
    
     #correct for Aces
     arr.select{|element| element == "Ace"}.count.times do
       break if total <= 21
       total -= 10
     end
     total
  end
  
  def card_image(card)
  suit = card[0]
  value = card[1]
  if ['Jack', 'Queen','King','Ace'].include?(value)
    value = case card[1]
      when 'Jack' then 'jack'
      when 'Queen' then 'queen'
      when 'King' then 'king'
      when 'Ace' then 'ace'   
    end
  end
      
  "<img src='/images/cards/#{suit}_#{value}.jpg' class='card'>" 

  end
end

before do
  @show_hit_or_stay_buttons = true
end

get '/' do
  if session[:player_name]
    redirect '/game'
  else
    redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  if params[:player_name].empty?
    @error = "Name is required"
    halt erb(:new_player)
  end
  session[:player_name] = params[:player_name]
  redirect '/game'
end

get '/game' do
  
  suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
  values = ['2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace']
  session[:deck] = suits.product(values).shuffle!
  
  #deal cards
  
  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
    #dealer cards
    #player cards
  
  erb :game
end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  player_total = calculate_total(session[:player_cards])
  if player_total == 21
    @success = "Congrats! #{session[:player_name]} hit blackjack!"
    @show_hit_or_stay_buttons = false
  elsif player_total > 21
    @error = "Sorry, it looks like #{session[:player_name]} busted."
    @show_hit_or_stay_buttons = false
  end
  erb :game
end

post '/game/player/stay' do
 @success = "You have chosen to stay!"
 @show_hit_or_stay_buttons = false
 erb :game
end


