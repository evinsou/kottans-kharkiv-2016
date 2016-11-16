class Position
  CHESSBOARD = (:a1..:h8)
  PIECE_NAMES = ['pawns', 'knights', 'bishops', 'rooks', 'queen', 'king']

  def initialize(arg_hash = {})
    @tiles = arg_hash
  end

  def occupied(type = nil)
    return proc { |cell| cell if value_for(cell) } unless type

    str_type = type.to_s
    unless correct_piece_name?(str_type)
      raise(ArgumentError, "it is not a correct piece name, known names are "\
        "#{PIECE_NAMES.join(', ')}")
    end

    proc do |cell|
      value = value_for(cell)
      cell if value && value[str_type]
    end
  end

  def to_proc
    proc { |cell| [cell, value_for(cell) || 'empty'] }
  end

  private

  def value_for(cell)
    @tiles[cell]
  end

  def correct_piece_name?(str_type)
    PIECE_NAMES.any? { |name| str_type == name || str_type.end_with?(name) }
  end
end
