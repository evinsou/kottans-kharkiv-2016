CHESSBOARD = (:a1..:h8)

class Position

  def initialize(arg_hash = {})
    
  end

  def occupied
    
  end

  def to_proc
    
  end
end

=begin
position = Position.new(a1: :black_queen, e2: :white_queen, h5: :white_bishop, ...)
CHESSBOARD.map(&position).to_h # => {a1: :black_queen, a2: :empty, a3: :empty...}
CHESSBOARD.select(&position.occupied) # => [:a1, :e2, :h5 ...]
CHESSBOARD.select(&position.occupied(:queen)) # => [:a1, :e2]
=end
