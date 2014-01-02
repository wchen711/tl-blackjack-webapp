# Class Card - individual card
# Class Decks - different status deck

SUITS = {S:'spades', H:'hearts', D:'diamonds', C:'clubs'}
FACES = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

class Card

	attr_accessor :face, :suit

	def initialize(face = nil, suit = nil)
		@face = face
		@suit = suit
	end

	def to_s
		"[#{face},#{suit}] "
	end

end

class Decks

	attr_accessor :cards_deck, :dealt_deck, :used_deck, :num_decks

	def initialize(num_decks = 1)
		create_card_deck(num_decks)
	end

	def deal_a_card
		if cards_deck.size == 0
			self.cards_deck += used_deck
			self.used_deck = []
			self.cards_deck.shuffle!
		end

		card = cards_deck.pop
		dealt_deck << card
		card
	end

	def finish_round
		self.used_deck += dealt_deck
		self.dealt_deck = []
	end

	def to_s
		"#{num_decks} Decks; Un-used Cards:#{cards_deck.size}; Cards Dealt:#{dealt_deck.size}; Used Cards:#{used_deck.size}"
	end

	def show_info
		puts to_s
		puts "Un-used Deck: " + show_cards(cards_deck)
		puts "Cards Dealt: " + show_cards(dealt_deck)
		puts "Used Cards: " + show_cards(used_deck)
		puts ""
	end

	private

	def create_card_deck(num_decks)
		@num_decks = num_decks

		self.dealt_deck = []
		self.used_deck = []
		self.cards_deck = []

		SUITS.each_key do |suit|
			FACES.each do |face|
				card = Card.new(face, suit)
				cards_deck << card
			end
		end

		cards_deck.shuffle!
	end

	def show_cards(deck)
		ret_val = ""
		deck.each { |card| ret_val += card.to_s}
		ret_val	
	end


end
