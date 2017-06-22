module Minimax
  def minimax(start_state, winning_lines)
    available_first_moves = @board.empty_squares
    minimaxed_scores = {}

    next_possible_board_states = available_first_moves.map do |move|
      next_state = board.try_move(move, @max_marker)
      [next_state, move]
    end

    next_possible_board_states.each do |next_state, move|
      score = minimax_score(next_state, min_player, players, winning_lines)
      minimaxed_scores[score] = move
    end

    optimal_score = minimaxed_scores.keys.max
    minimaxed_scores[optimal_score]
  end

  private

  def assess(winner, max_player, min_player)
    case winner
    when max_player then 1
    when min_player then -1
    else 0
    end
  end

  def maximize_score(next_possible_board_states, players, winning_lines)
    score = -2
    min_player = players.last

    next_possible_board_states.each do |next_state|
      next_score = minimax_score(next_state, min_player, players, winning_lines)
      score = [score, next_score].max
    end

    score
  end

  def minimize_score(next_possible_board_states, players, winning_lines)
    score = 2
    max_player = players.first

    next_possible_board_states.each do |next_state|
      next_score = minimax_score(next_state, max_player, players, winning_lines)
      score = [score, next_score].min
    end

    score
  end

  def minimax_score(board, current_player, players, winning_lines)
    max_player = players.first
    min_player = players.last

    if end_of_game?(board, winning_lines)
      winner = detect_winner(board, winning_lines)
      return assess(winner, max_player, min_player)
    end

    available_moves = empty_squares(board)
    next_possible_board_states = available_moves.map do |move|
      try_move(board, move, current_player)
    end

    if current_player == max_player
      maximize_score(next_possible_board_states, players, winning_lines)
    else
      minimize_score(next_possible_board_states, players, winning_lines)
    end
  end
end