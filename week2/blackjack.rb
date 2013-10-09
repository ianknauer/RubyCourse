class Blackjack
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
  
  def self.getValue (card)
    @@values["#{card.face_value}"]
  end
  
end

class Card
  attr_accessor :face_value
  
  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end
  
  def show_card
    "#{@face_value} of #{@suit}"
  end 
end

class Player
  def initialize(deck)
    @deck = deck
    @hand = []
  end
  
  def show_hand
    @hand.each do |card|
      puts card.show_card
    end
  end
  
  def hit
     @hand << @deck.deal
   end
   
  def player_score
    total = 0
    @@aces = 0
      @hand.each do |card| 
       total += Blackjack.getValue(card)
      end
      total
  end
end
  
class Deck
  # arrays for creating the deck
  @@suits = ["Hearts","Spades", "Diamonds", "Clubs"]
  @@face_values = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack","Queen", "King", "Ace"]
  
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
    @cards.shuffle
  end
end

blackjackGame = Blackjack.new
game_deck = Deck.new()
player1 = Player.new(game_deck)
player1.hit
player1.hit
player1.show_hand
puts "#{player1.player_score}"