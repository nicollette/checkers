# encoding: utf-8
require_relative 'piece'

class Board
  def initialize(fill_board = true)
    @rows = Array.new(8) { Array.new(8) }
    if fill_board
      set_pieces(:red)
      set_pieces(:white)
    end
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
    piece.pos = pos # ensures update of position when used in #move_piece
  end
  
  def move_piece(piece, move)
    self[piece.pos] = nil #updates old pos on board to nil
    place_piece(piece, move) # place piece at new pos
  end
  
  def remove_piece(piece)
    self[piece.pos] = nil #removes piece from board
    piece.pos = []  # sets piece's pos to []
  end
  
  def within_bounds?(pos)
    x, y = pos
    x.between?(0, 7) && y.between?(0, 7)
  end
  
  def display_board
    puts "  0  1  2  3  4  5  6  7"
    
    @rows.each_index do |row_idx|
      print "#{row_idx} "
      
      8.times do |col_idx|
        pos = [row_idx, col_idx]
        if self[pos].nil?
          print "___"
        elsif self[pos].color == :red
          print "◉__"
        else
          print "◎__"
        end
      end
      
      puts
    end
  end
  
  def dup_board
    duped_board = Board.new(false)
    
    @rows.each_index do |row_idx|
      8.times do |col_idx|
        pos = [row_idx, col_idx]
        next if self[pos].nil?
        color = self[pos].color
        
        Piece.new(pos, color, duped_board)
      end
    end
    duped_board
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

new_board = Board.new
new_board.display_board
pc = new_board[[2, 1]]

pc.perform_slide([3, 2])
puts "peform slide 1"
new_board.display_board

pc2 = new_board[[5, 2]]
pc2.perform_slide([4, 3])
puts "peform slide 2"
new_board.display_board

pc2.perform_jump([2, 1])
puts "peform jump"
new_board.display_board
