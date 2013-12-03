require 'debugger'
class InvalidMoveError < StandardError
end

class Piece
  attr_accessor :pos, :color, :board, :king
  
  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
    
    @board.place_piece(self, pos)
  end
  
  def forward_dir(color)
    forward = (color == :red) ? 1 : -1
  end
  
  def perform_slide(move)
    cur_x, cur_y = @pos

    if possible_slides.include?(move)
      @board.move_piece(self, move)
      @king ||= promote?
      true
    else 
      false
    end
  end
  
  def possible_slides
    cur_x, cur_y = @pos
    possible_moves = []

    move_diffs.each do |dx, dy|
      new_pos = [cur_x + dx, cur_y + dy]
      possible_moves << new_pos if @board[new_pos].nil? 
    end

    possible_moves
  end
  
  def perform_jump(move)
    cur_x, cur_y = @pos
    
    move_diffs.each do |dx, dy|
      jumped_pos = [cur_x + (2 * dx), cur_y + (2 * dy)]
      next unless move == jumped_pos
      
      adjacent_pos = [cur_x + dx, cur_y + dy]
      adjacent_piece = @board[adjacent_pos]
      
      if !adjacent_piece.nil? && adjacent_piece.color != @color
        @board.remove_piece(adjacent_piece)
        @board.move_piece(self, move)
        @king ||= promote?
        return true
      end
    end
    false
  end
  
  def promote?
    kings_row = @color == :red ? 7 : 0
    @pos[0] == kings_row
  end
  
  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError
    end
  end
  
  def perform_moves!(move_sequence)
    performed_move = true
    
    if move_sequence.any? { |move| !@board.within_bounds?(move) }
      performed_move = false 
    elsif move_sequence.count == 1
      move = move_sequence.flatten
      
      unless perform_slide(move)
        performed_move = false unless perform_jump(move)
      end
    else
      move_sequence.each do |move|
        performed_move = false unless perform_jump(move)
      end
    end

    raise InvalidMoveError unless performed_move
  end
  
  def valid_move_seq?(move_sequence)
    duped_piece = @board.dup_board[@pos]
    
    begin
      duped_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError => error
      puts "~~~ Invalid Move ~~~"
      false
    else
      true
    end
  end
  
  def move_diffs
    if @king 
      [[1, -1], [-1, -1], [1, 1], [-1, 1]] 
    else
      x = forward_dir(@color)
      [[x, -1], [x, 1]]
    end 
  end
end