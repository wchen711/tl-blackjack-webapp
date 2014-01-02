# Class Player - player info, status, and state
# Class Dealer - inheriting Player Class

require_relative 'decks'

class Player

	attr_accessor :name, :coins, :hand

	def initialize(name = "", coins = 500)
		@name = name
		@coins = coins
		@hand = []
	end

	def receive_a_card(card)
		hand << card
	end

	def finish_round
			@hand = []
	end

	def <=>(val)
		total <=> val
	end

	def to_s
		cards = ""
		hand.each { |card| cards += card.to_s }
		"#{name} has hand: #{cards}, with value of:#{total}" 
	end

	def total
		face_values = @hand.map { |card| card.face }

		value = 0
		face_values.each do |val|
      if val == "A"
        value += 11
      else
        value += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

		face_values.select{|val| val == "A"}.count.times do
      break if value <= 21
      value -= 10
    end

		value
	end

end


class Dealer < Player

	def continue?
		if total >= 17
			return false
		else
			return true
		end
	end

end



