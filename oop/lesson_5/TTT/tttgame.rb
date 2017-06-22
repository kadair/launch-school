require_relative 'board'
require_relative 'square'
require_relative 'player'
require_relative 'displayable'
require 'pry'

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = :choose
  DIFFICULTY = :choose
  SIDE_LENGTH = 3

  include Displayable

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new(SIDE_LENGTH)
    @human = Human.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER)
    @current_marker = decide_first_player
    @difficulty = decide_difficulty
  end

  def decide_first_player
    return FIRST_PLAYER unless FIRST_PLAYER == :choose

    answer = input("Do you want to go first? (y or n)", %w[y yes n no])
    answer.start_with?('y') ? PLAYER_MARKER : COMPUTER_MARKER
  end

  def decide_difficulty
    difficulty = if DIFFICULTY == :choose
                   user_inputs_difficulty
                 else
                   DIFFICULTY
                 end

    if difficulty == :impossible && disable_hardest_difficulty?
      prompt("'Impossible' difficulty disabled on boards greater than 3x3.")
      difficulty = user_inputs_difficulty
    end

    difficulty
  end

  def disable_hardest_difficulty?
    SIDE_LENGTH > 3
  end

  def user_inputs_difficulty
    if disable_hardest_difficulty?
      message = 'easy (e) or hard (h)'
      options = %w[e easy h hard]
    else
      message = 'easy (e), hard (h), or impossible (i)'
      options = %w[e easy h hard i impossible]
    end

    prompt("Choose your difficulty: ")
    answer = input(message, options)

    case answer.chr
    when 'e' then :easy
    when 'h' then :hard
    when 'i' then :impossible
    end
  end

  def play
    clear
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end

      display_result
      break unless play_again?
      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def alternate_player
    if human_turn?
      @current_marker = COMPUTER_MARKER
    else
      @current_marker = HUMAN_MARKER
    end
  end

  def clear
    system('clear') || system('cls')
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def computer_moves
    board[board.unmarked_keys.sample] = computer.marker
  end

  def current_player_moves
    human_turn? ? human_moves : computer_moves
    alternate_player
  end

  def display_board
    puts "You're #{human.marker}. Computer is #{computer.marker}."
    puts ""
    board.draw
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "The board is full!"
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def human_moves
    puts "Choose a square (#{board.unmarked_keys.join(', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end
end

game = TTTGame.new
game.play