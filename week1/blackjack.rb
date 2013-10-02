def space
  puts ""
end

def deal_card(person, num_cards, deck)
  num_cards.times do 
    person << deck.shift
  end
end

def score(person)
  score = 0
  acecount = 0
  person.each do |card|
    if card[:card] == 'Ace'
      acecount = acecount + 1
    else
      score = score + (card[:value])
    end
  end
  acecount.times do
    if score <= (10 - (acecount - 1))
      score = score + 11
    else
      score = score + 1
    end
  end
  score
end

def cards(person)
 person.each do |card|
   puts "a #{card[:card]} of #{card[:suit]}"
  end
end
     
player = []
dealer = []
player_score = 0
dealer_score = 0
play_again = "yes"
suits = ['diamonds', 'hearts', 'spades', 'clubs']
cards = ['2','3','4','5','6','7','8','9','10', 'Jack', 'Queen', 'King', 'Ace']
values = [2,3,4,5,6,7,8,9,10,10,10,10, [1,11]]
deck = []

suits.each do |list|
  value_position = 0
  cards.each do |card|
    deck  << {suit: list, card: card, value: values[value_position]}
    value_position += 1
  end
end

while play_again == "yes"
  puts 'Hello, welcome to my blackjack table... what is your name?'
  name = gets.chomp; space
  puts "hello #{name}, prepare to lose!"; space
  puts "shuffle.. shuffle... shuffle.. so how about that there weather.."; space
  game_deck = Array.new(deck.shuffle*rand(1..3))
  puts "DEALER ROBOT IS DEALING"
  deal_card(player, 2, game_deck)
  puts "your cards are..."
  cards(player)
  player_score = score(player)
  
  while player_score < 21
    puts "your hand value is now #{player_score}, what would you like to do? hit or stay?"
    choice = gets.chomp
      if choice == "hit"
        deal_card(player, 1, game_deck)
        puts "your cards are..."
        cards(player)
        player_score = score(player)
      elsif choice == "stay"
        puts "okay, you're going to stay at #{player_score}, let's see what i'm going to get.."
        break
      else 
      end
  end

  if player_score > 21
    puts "sorry, you went over... you lose"
  elsif player_score == 21
    puts "blackjack! you win"
  else
    deal_card(dealer, 2, game_deck)
    puts "my cards are..."
    cards(dealer)
    dealer_score = score(dealer)
    puts "my score is #{dealer_score}"  
    while dealer_score < 17
      puts "drawing a new card.."
      deal_card(dealer, 1, game_deck)
      puts "my cards are..."
      cards(dealer)
      dealer_score = score(dealer)
      puts "my score is #{dealer_score}"
    end
    if (dealer_score > 21) || (player_score > dealer_score)
      puts "#{name} You have defeated me, you vile monster!"
    else
      puts "MUAHAHAHAH #{name} bow down before me"
    end
  end
  player = []
  dealer = []
  puts "would you like to play again? yes/no"
  play_again = gets.chomp
end   


