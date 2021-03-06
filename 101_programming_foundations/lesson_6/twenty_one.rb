# twenty_one.rb

CARD_SUITS = ['hearts', 'diamonds', 'clubs', 'spades']
CARD_VALUES = ('2'..'10').to_a.concat(['J', 'Q', 'K', 'A'])
CARD_SCORES = (2..10).to_a.concat([10, 10, 10, 11])

CARD_SCORE_TABLE = CARD_VALUES.zip(CARD_SCORES).to_h

WINNING_SCORE = 5

GOAL = 21
DEALER_CUTOFF = 17
STARTING_DEAL_NUM_CARDS = 2
GAME_NAME = "Twenty-One"

### UI methods ###

def prompt(message)
  puts "\n>>#{message}"
end

def display_welcome
  clear
  prompt("Welcome to #{GAME_NAME}! First to #{WINNING_SCORE} wins!")
end

def user_inputs_name
  loop do
    prompt('What is your name?')
    name = gets.chomp
    return name if name =~ /^\w+/
    prompt('Not a valid name.')
  end
end

def user_chooses_option(message, options)
  loop do
    prompt("Do you want to #{message}")
    answer = gets.chomp.downcase
    return answer if options.include?(answer)
    prompt("Please enter #{options.join(', ')}")
  end
end

def clear
  system('clr') || system('clear')
end

def format_card(card)
  value = card[0]
  suit = card[1]
  "|| #{value} of #{suit} ||"
end

def show_first(hand)
  first_card = hand.first
  remaining_cards = hand[1..-1]
  formatted_cards = []

  formatted_cards << format_card(first_card)
  remaining_cards.each { formatted_cards << format_card(['?', '?']) }

  formatted_cards
end

def show_all(hand)
  hand.map { |card| format_card(card) }
end

def format_player_hand(hand, player)
  ["#{player}'s hand:"] + show_all(hand)
end

def format_dealer_hand(hand, hide_dealer_cards)
  ["Dealer's hand:"] + (hide_dealer_cards ? show_first(hand) : show_all(hand))
end

def wait_for_dealer
  prompt("Dealer is flipping a card...")
  sleep(1)
end

def display_hands(hands, player, hand_scores, hide_dealer_cards)
  player_hand, dealer_hand = hands
  player_score, dealer_score = hand_scores.values

  clear
  puts format_player_hand(player_hand, player)
  puts "#{player}'s total: #{player_score}"
  puts
  puts format_dealer_hand(dealer_hand, hide_dealer_cards)
  puts "Dealer's total: #{dealer_score}" unless hide_dealer_cards
end

def display_round_winner(winner, buster)
  result = ''

  result += "#{buster.capitalize} busts! " if buster
  result += (winner ? "#{winner.capitalize} wins!" : "It's a tie!")

  prompt(result)
end

def display_game_scores(scores)
  puts "\nCurrent score:"
  scores.each { |player, score| puts "| #{player.capitalize}: #{score} |" }
end

def display_game_winner(winner)
  puts("--------------------------")
  prompt("#{winner.capitalize} wins the game!")
end

### Game methods ###

def new_shuffled_deck
  CARD_VALUES.product(CARD_SUITS).shuffle
end

def adjust_score_for_aces(hand, score)
  aces = hand.select { |card| card.first == 'A' }

  new_score = score
  aces.each { new_score -= 10 if new_score > GOAL }

  new_score
end

def calculate_hand_score(hand)
  card_scores = hand.map { |card| CARD_SCORE_TABLE[card.first] }
  total_score = card_scores.reduce(:+)

  adjust_score_for_aces(hand, total_score)
end

def update_hand_score!(player, hand, hand_scores)
  hand_scores[player] = calculate_hand_score(hand)
end

def update_scores!(player, hands, hand_scores)
  player_hand, dealer_hand = hands
  update_hand_score!(player, player_hand, hand_scores)
  update_hand_score!(:dealer, dealer_hand, hand_scores)
end

def hit!(hand, deck)
  hand << deck.pop
end

def deal!(n, hands, deck)
  player_hand, dealer_hand = hands

  n.times do
    hit!(player_hand, deck)
    hit!(dealer_hand, deck)
  end
end

def busted?(score)
  score > GOAL
end

def detect_buster(hand_scores, player)
  player_score, dealer_score = hand_scores.values

  if busted?(player_score)
    player
  elsif busted?(dealer_score)
    :dealer
  end
end

def round_winner_by_score(hand_scores, player)
  player_score, dealer_score = hand_scores.values

  if player_score > dealer_score
    player
  elsif dealer_score > player_score
    :dealer
  end
end

def detect_winner(player, hand_scores)
  if busted?(hand_scores[:dealer])
    player
  elsif busted?(hand_scores[player])
    :dealer
  else
    round_winner_by_score(hand_scores, player)
  end
end

def player_plays!(hands, deck, player, hand_scores)
  player_hand = hands.first

  loop do
    answer = user_chooses_option("hit or stay? (h or s)", %w[h s hit stay])

    hit!(player_hand, deck) if answer.start_with?('h')
    update_hand_score!(player, player_hand, hand_scores)
    display_hands(hands, player, hand_scores, true)

    break if busted?(hand_scores[player]) || answer.start_with?('s')
  end
end

def dealer_plays!(hands, deck, player, hand_scores)
  dealer_hand = hands.last

  display_hands(hands, player, hand_scores, false)

  loop do
    break if hand_scores[:dealer] >= DEALER_CUTOFF

    wait_for_dealer
    hit!(dealer_hand, deck)
    update_hand_score!(:dealer, dealer_hand, hand_scores)

    display_hands(hands, player, hand_scores, false)
  end
end

def play!(hands, deck, player, hand_scores)
  player_plays!(hands, deck, player, hand_scores)
  return if busted?(hand_scores[player])
  dealer_plays!(hands, deck, player, hand_scores)
end

### Main game methods ###

def update_game_scores(player, game_scores)
  game_scores[player] += 1
end

def game_winner?(winner, scores)
  scores[winner] == WINNING_SCORE
end

def play_round(player)
  deck = new_shuffled_deck
  hands = [[], []]
  hand_scores = { player => nil, :dealer => nil }

  deal!(STARTING_DEAL_NUM_CARDS, hands, deck)
  update_scores!(player, hands, hand_scores)
  display_hands(hands, player, hand_scores, true)

  play!(hands, deck, player, hand_scores)

  winner = detect_winner(player, hand_scores)
  buster = detect_buster(hand_scores, player)

  [winner, buster]
end

### Main ###

display_welcome
player = user_inputs_name.capitalize

loop do # game loop
  game_scores = { player => 0, :dealer => 0 }

  loop do # round loop
    winner, buster = play_round(player)
    display_round_winner(winner, buster)

    update_game_scores(winner, game_scores) if winner
    display_game_scores(game_scores)

    if game_winner?(winner, game_scores)
      display_game_winner(winner)
      break
    else
      play_again = user_chooses_option('play again? (y or n)', %w[y n yes no])
      break if play_again.start_with?('n')
    end
  end

  restart = user_chooses_option('start a new game? (y or n)', %w[y n yes no])
  break if restart.start_with?('n')
end

prompt("Goodbye, #{player}!")
