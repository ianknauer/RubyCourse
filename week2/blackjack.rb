require 'pry'

class Blackjack
   attr_accessor :game_deck, :player, :dealer
   
  @@values = {  "Ace" => 11, 
                "Two" => 2, 
                "Three" => 3, 
                "Four" => 4, 
                "Five" => 5, 
                "Six" => 6, 
                "Seven" => 7, 
                "Eight" => 8, 
                "Nine" => 9, 
                "Ten" => 10, 
                "Jack" => 10, 
                "Queen" => 10, 
                "King" => 10}
                
  def initialize
    @game_deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end
  
  def start
     set_player_name
     deal_cards
     first_show
     players_turn
     dealers_turn
     who_won?
   end
  
  def set_player_name
     puts "What's your name?"
     player.name = gets.chomp
   end
                
  def deal_cards
    player.hit(game_deck.deal)
    player.hit(game_deck.deal)
    dealer.hit(game_deck.deal)
    dealer.hit(game_deck.deal)
  end
  
  def first_show
    player.first_show
    dealer.first_show
  end
  
  def win_or_break?(card_holder)
    if card_holder.score == 21
      if card_holder.is_a?(Dealer)
        puts "Sorry #{player.name}, but the dealer won"
      else
        puts "Congratulations, You hit blackjack. You win the prize!"
      end
    play_again?
    elsif card_holder.is_busted?
      if card_holder.is_a?(Dealer)
        puts "Congrats #{player.name}! you win!!!!!"
      else 
        puts "Aw man.. #{player.name} busted. what a drag.."
      end
      play_again?
    end
  end
  
  def play_again?
    puts "-----------------"
    puts "would you like to play again? Yes or No"
    if gets.chomp == 'yes' || gets.chomp == 'Yes'
      puts "YEAAAAAAHHHHH *sun glasses*"
      puts ""
      deck = Deck.new
      player.hand = []
      dealer.hand = []
      start
    else
      puts "Alrighty then. Goodbye!"
      exit
    end
  end
  
  def dealers_turn
     puts "#{dealer.name}'s turn now"
     puts 
     win_or_break?(dealer)
     while dealer.score < 17
        new_card = game_deck.deal
        puts "#{dealer.name} gets a new card. It is a #{new_card.show_card}"
        dealer.hit(new_card)
        puts "#{dealer.name}'s total is now #{player.score}"
        win_or_break?(player)
     end
     puts "Dealer stays at #{dealer.score}."
   end
   
   def who_won?
     if player.score > dealer.score
       puts "Congratulations, #{player.name} wins!"
     elsif player.score < dealer.score
       puts "Sorry, #{player.name} loses."
     else
       puts "It's a tie!"
     end
     play_again?
   end
  
  def players_turn
    puts "#{player.name}'s turn first"
    
    win_or_break?(player)
    
    while !player.is_busted?
      puts "What would you like to do? Hit or stay?"
      answer = gets.chomp
      if not ['Hit','hit','Stay','stay'].include?(answer)
        puts "Well that has nothing to do with the game.. Would you like to hit or stay?"
        next
      end
      
      if answer == 'Stay' || answer == 'stay'
        puts "whoop de doo, #{player.name} decided to stay at #{player.score}"
        break
      end
      
      new_card = game_deck.deal
      puts "#{player.name} gets a new card. It is a #{new_card.show_card}"
      player.hit(new_card)
      puts "#{player.name}'s total is now #{player.score}"
    end
    win_or_break?(player)
  end
  
  def self.getValue (card)
    @@values["#{card.face_value}"]
  end
  
end

class Card
  attr_accessor :face_value, :suit
  
  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end
  
  def show_card
    "#{@face_value} of #{@suit}"
  end 

end

module Hand
  
  def show_hand
    puts "---- #{name}'s Hand ----"
    @hand.each do |card|
      puts "=> #{card.show_card}"
    end
  end
  
  def score
    @total = 0
    @@aces = 0
      @hand.each do |card| 
        if card.face_value == 'Ace'
          @total += Blackjack.getValue(card)
          @@aces += 1
        else
          @total += Blackjack.getValue(card)
        end
      end
      while @total > 21 && @@aces > 0
          @total = @total - 10
          @@aces = @@aces - 1
      end
      @total
  end
  
  def hit(cards)
     @hand << cards
   end
   
  def is_busted?
     score > 21 
   end
end


class Player
  include Hand
  
  attr_accessor :name, :hand
  def initialize() 
    @hand = []
    @name = "Ian"
  end
  
  def first_show
    puts "---- #{name}'s Hand ----"
    @hand.each do |card|
      puts "=> #{card.show_card}"
    end
    puts "=> Your hand value is: #{score}"
  end
end

class Dealer
  include Hand
  
  attr_accessor :hand, :name
  def initialize() 
    @hand = []
    @name = "dealer"
  end
  
  def first_show
    puts "---- #{name}'s Hand ----"
    puts "The dealers first card remains unflipped"
    puts "=> #{hand[1].show_card}"
   end
end
  
class Deck
  attr_accessor :cards
  # arrays for creating the deck
  @@suits = ["Hearts","Spades", "Diamonds", "Clubs"]
  @@face_values = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Ace"]
  
  def initialize
    @cards = []
    @@suits.each do |suit|
      @@face_values.each do |value|
        @cards << Card.new(suit, value)
      end
    end
    truffle_shuffle
  end
  
  def deal
    @cards.pop
  end
  
  def show_cards
    @cards.each do |card|
      puts card
    end
  end
  
  private
  
  def truffle_shuffle
    @cards.shuffle!
  end
end

game = Blackjack.new
game.start






