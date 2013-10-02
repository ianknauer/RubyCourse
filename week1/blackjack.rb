deck = [{suit:'hearts', card:'2', value: 2},        {suit:'hearts', card:'3', value: 3},
        {suit:'hearts', card:'4', value: 4},          {suit:'hearts', card:'5', value: 5},        {suit:'hearts', card:'6', value: 6},
        {suit:'hearts', card:'7', value: 7},          {suit:'hearts', card:'8', value: 8},        {suit:'hearts', card:'9', value: 9},
        {suit:'hearts', card:'10', value: 10},        {suit:'hearts', card:'Jack', value: 10},    {suit:'hearts', card:'Queen', value: 10},
        {suit:'hearts', card:'King', value: 10},      {suit:'hearts', card:'Ace', value: [1,11]},  
        {suit:'diamonds', card:'2', value: 2},        {suit:'diamonds', card:'3', value: 3},      {suit:'diamonds', card:'4', value: 4},
        {suit:'diamonds', card:'5', value: 5},        {suit:'diamonds', card:'6', value: 6},      {suit:'diamonds', card:'7', value: 7},
        {suit:'diamonds', card:'8', value: 8},        {suit:'diamonds', card:'9', value: 9},      {suit:'diamonds', card:'10', value: 10},
        {suit:'diamonds', card:'Jack', value: 10},    {suit:'diamonds', card:'Queen', value: 10}, {suit:'diamonds', card:'King', value: 10},
        {suit:'diamonds', card:'Ace', value: [1,11]}, {suit:'clubs', card:'2', value: 2}, 
        {suit:'clubs', card:'3', value: 3},           {suit:'clubs', card:'4', value: 4},         {suit:'clubs', card:'5', value: 5},
        {suit:'clubs', card:'6', value: 6},           {suit:'clubs', card:'7', value: 7},         {suit:'clubs', card:'8', value: 8},
        {suit:'clubs', card:'9', value: 9},           {suit:'clubs', card:'10', value: 10},       {suit:'clubs', card:'Jack', value: 10},
        {suit:'clubs', card:'Queen', value: 10},      {suit:'clubs', card:'King', value: 10},     {suit:'clubs', card:'Ace', value: [1,11]},
        {suit:'spades', card:'2', value: 2},        {suit:'spades', card:'3', value: 3},
        {suit:'spades', card:'4', value: 4},          {suit:'spades', card:'5', value: 5},        {suit:'spades', card:'6', value: 6},
        {suit:'spades', card:'7', value: 7},          {suit:'spades', card:'8', value: 8},        {suit:'spades', card:'9', value: 9},
        {suit:'spades', card:'10', value: 10},        {suit:'spades', card:'Jack', value: 10},    {suit:'spades', card:'Queen', value: 10},
        {suit:'spades', card:'King', value: 10},      {suit:'spades', card:'Ace', value: [1,11]}
        ]
              
def space
  puts ""
end

def dealcard(person, num_cards, deck)
  for n in 1..(num_cards)
    person << deck.shift
  end
end

def score(person)
  score = 0
  acecount = 0
  for n in 0..((person.length-1))
    if person[n][:card] == 'Ace'
      acecount = acecount + 1
    else
      score = score + (person[n][:value])
    end
  end
  for n in 0..(acecount - 1)
    if score <= (10 - (acecount - 1))
      score = score + 11
    elsif
      score = score + 1
    end
  end
  score
end

def cards(person)
 for n in 0..((person.length-1))
   puts "a #{person[n][:card]} of #{person[n][:suit]}"
  end
end
     
player = []
dealer = []
playerScore = 0
dealerScore = 0
playAgain = "yes"

while playAgain == "yes"
  puts 'Hello, welcome to my blackjack table... what is your name?'
  name = gets.chomp; space
  puts "hello #{name}, prepare to lose!"; space
  puts "shuffle.. shuffle... shuffle.. so how about that there weather.."; space
  game_deck = Array.new(deck.shuffle*rand(1..3))
  puts "DEALER ROBOT IS DEALING"
  dealcard(player, 2, game_deck)
  puts "your cards are..."
  cards(player)
  playerScore = score(player)

  while playerScore < 21
    puts "your hand value is now #{playerScore}, what would you like to do? hit or stay?"
    choice = gets.chomp
      if choice == "hit"
        dealcard(player, 1, game_deck)
        puts "your cards are..."
        cards(player)
        playerScore = score(player)
      elsif choice == "stay"
        puts "okay, you're going to stay at #{playerScore}, let's see what i'm going to get.."
        break
      else 
      end
  end

  if playerScore > 21
    puts "sorry, you went over... you lose"
  elsif playerScore == 21
    puts "blackjack! you win"
  else
    dealcard(dealer, 2, game_deck)
    puts "my cards are..."
    cards(dealer)
    dealerScore = score(dealer)
    puts "my score is #{dealerScore}"  
    while dealerScore < 17
      puts "drawing a new card.."
      dealcard(dealer, 1, game_deck)
      puts "my cards are..."
      cards(dealer)
      dealerScore = score(dealer)
      puts "my score is #{dealerScore}"
    end
    if (dealerScore > 21) || (playerScore > dealerScore)
      puts "#{name} You have defeated me, you vile monster!"
    else
      puts "MUAHAHAHAH #{name} bow down before me"
    end
  end
  player = []
  dealer = []
  puts "would you like to play again? yes/no"
  playAgain = gets.chomp
end   


