require_relative 'piece'

class Board
  def initialize
    @rows = Array.new(8) { Array.new(8) }
    set_pieces(:red)
    set_pieces(:white)
  end
  
  def [](pos)
    x, y = pos
    @rows[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @rows[x][y] = piece
  end
  
  def place_piece(piece, pos)
    self[pos] = piece
  end
  
  protected
  def set_pieces(color)
    rows = color == :red ? [0, 1, 2] : [5, 6, 7]
    
    rows.each do |row_idx|
      8.times do |col_idx|
        pos = [row_idx, col_idx]
        
        if row_idx.even? && col_idx.odd?
          Piece.new(pos, color, self)
        elsif row_idx.odd? && col_idx.even?
          Piece.new(pos, color, self)
        end      
      end
    end
  end
end

p Board.new