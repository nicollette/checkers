class InvalidPieceError < StandardError
end

class NoPieceError < StandardError
end

require_relative 'board'

class Game
  attr_accessor :current_player
  
  def initialize(player1, player2)
    @board = Board.new
    @players = { :red => player1, :white => player2}
    @current_player = :red
  end
  
  def play
    
    while true
      begin
        puts
        puts "#{@current_player}'s move \n\n"
        @board.display_board
        
        piece_pos = @players[current_player].choose_piece
        selected_piece = @board[piece_pos]
        
        raise NoPieceError if selected_piece.nil?
        raise InvalidPieceError if selected_piece.color != @current_player
        
        moves = @players[current_player].choose_moves
        selected_piece.perform_moves(moves)
        
      rescue NoPieceError => error
        puts "There is no piece there."
      rescue InvalidPieceError => error
        puts "You can't move the opponent's piece."
        puts "Please select a #{current_player} piece."
        retry
      rescue InvalidMoveError => error
        puts "Invalid move sequence, please enter again."
        retry
      end
      
      break if won?(current_player)
      @current_player = @current_player == :red ? :white : :red
    end
    
    @board.display_board
    puts "GAME OVER"
    puts "#{@current_player} WON!"
  end
  
  def won?(current_player)
    opposing_pieces = @board.pieces.select do |piece| 
      piece.color != current_player
    end
    opposing_pieces.empty?
  end
end

class HumanPlayer
  
  def choose_moves
    moves = []
    
      while true
        puts "Enter the move you want to make (format: x, y)"
        puts "Enter q when done"
        move = gets.chomp
        
        if move == "q"
          break
        else
          x, y = move.split(", ")
          moves << [Integer(x), Integer(y)]
        end
      end
  
    moves
  end
  
  def choose_piece
    begin
      puts "What piece do you want to move? (format: x, y)"
      x, y = gets.chomp.split(", ")
      [Integer(x), Integer(y)]
    rescue ArgumentError => error
      puts "Please enter a valid position (format: x, y)"
      retry
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  new_game = Game.new(HumanPlayer.new, HumanPlayer.new)
  new_game.play
end