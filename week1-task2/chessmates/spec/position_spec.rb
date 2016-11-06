require 'spec_helper'

describe Position do
  let(:data_hash) { {a1: :black_queen, e2: :white_queen, h5: :white_bishop} }
  let(:position) { Position.new(data_hash) }
  let(:empty_fields) do
    field_hash = Position::CHESSBOARD.map(&position).to_h
    field_hash.values.select { |val| val == 'empty' }
  end

  it 'returns a full map with occupied and empty tiles' do
    expect(empty_fields.size).to eq(75)
  end

  context 'when data hash is empty' do
    let(:data_hash) { {} }

    it 'returns empty board' do
      expect(empty_fields.size).to eq(78)
    end
  end

  describe '#occupied' do
    let(:piece_name) { nil }
    let(:occupied_boxes) do
      Position::CHESSBOARD.select(&position.occupied(piece_name))
    end

    it 'returns all occupied tiles' do
      expect(occupied_boxes).to eq([:a1, :e2, :h5])
    end

    context 'when piece name is specificed' do
      let(:piece_name) { :queen }

      it 'returns occupied tiles of the figure' do
        expect(occupied_boxes).to eq([:a1, :e2])
      end
    end

    context 'when the piece is not present' do
      let(:piece_name) { :king }

      it 'does not return any tiles ' do
        expect(occupied_boxes).to eq([])
      end
    end

    context 'when wrong name of piece is entered' do
      let(:piece_name) { :queens }

      it 'raises an error' do
        expect { occupied_boxes }.to raise_error(ArgumentError)
      end
    end
  end
end
