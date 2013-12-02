class Piece
  attr_accessor :pos, :color, :board, :king
  
  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
    
    board.place_piece(self, pos)
  end
end