require 'byebug'

class Capybara

  attr_accessor :fatigue, :hunger, :color

  ONE_YEAR = 365 * 24 * 60 * 60

  def initialize(fatigue: 0, hunger: 0, color: 'brown')
    @fatigue = fatigue
    @hunger = hunger
    @color = color
    @born_at = Time.now
    @alive = true
  end

  def age
    (Time.now - @born_at).to_i
  end

  def walk
    raise_dead_unless { alive? }

    @hunger += 1.5
    @fatigue += 2
    'chlop, chlop'
  end

  def eat
    raise_dead_unless { alive? }

    @hunger = 0
    @fatigue += 1
    'yammi food'
  end

  def sound
    raise_dead_unless { alive? }

    @hunger += 0.2
    @fatigue += 0.5
    "clicking.. grunting.. squealing..."
  end

  def swim
    raise_dead_unless { alive? }

    @hunger += 4
    @fatigue += 3
    'Swish, swish, swish'
  end

  def sleep
    raise_dead_unless { alive? }

    @hunger += 0.5
    @fatigue = 0
    'Hrreeh, Hrreeh...'
  end

  def alive?
    (age / ONE_YEAR).to_i < 12
  end

  private

  def raise_dead_unless &block
    raise IAmDead unless block.call
  end
end
