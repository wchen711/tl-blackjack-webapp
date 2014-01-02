require 'rubygems'
require 'sinatra'
require_relative 'game'

set :sessions, true

STATUS = ["None", \
					"Dealer Win! Dealer Black Jack!", \
					"Player Win! Player Black Jack!", \
					"Player Loss! Player Busted!", \
					"Dealer Loss! Dealer Busted!", \
					"Dealer Busted!  But Player Busted First!", \
					"Player Win!", \
					"Dealer Win!", \
					"Push!"]

helpers do
	def get_card_img_string(card)
		suit = card.suit
		suit_name = SUITS[suit.to_sym]
		face = case card.face
			when "A" then "ace"
			when "J" then "jack"
			when "Q" then "queen"
			when "K" then "king"
			else card.face.to_s
		end

		card_string = "images/cards/#{suit_name}_#{face}.jpg"
	end

	def get_result_message(ix)
		STATUS[ix]
	end
end

#before do
#  @player_can_continue = true
#end

def get_result(state)
	game = session[:game]
	player_name = session[:player_name]

	dealer_total = game.get_dealer_total
	player_total = game.get_player_total(player_name)

	if state == 0
		if game.dealer_21? && game.player_21?(player_name)
			status = 8
		elsif game.dealer_21?
			status = 1
		elsif game.player_21?(player_name)
			status = 2
		else
			status = 0
		end
	
	elsif state == 1
		status = player_total > 21 ? 3 : 0

	elsif state == 2
		if player_total > 21
			status = dealer_total > 21 ? 5 : 7
		elsif dealer_total > 21
			status = 4
		elsif dealer_total > player_total
			status = 7
		elsif dealer_total < player_total
			status = 6
		else
			status = 8
		end

	end

	return status

end


get '/' do
	session[:game] = Game.new
	erb :welcome
end

post '/set_name' do
	@player_name = params[:player_name]
	session[:player_name] = @player_name
	session[:game].add_player(@player_name)
	erb :name_set
end

get '/deal_initial_cards' do
	game = session[:game]
	game.finish_round
	@player_name = session[:player_name]

	game.deal_initial_hand
	@dealer_cards = game.get_dealer_cards
	@player_cards = game.get_player_cards(@player_name)

	@status = get_result(0)

	@player_can_continue = @status == 0 ? true : false

	erb :display_cards
end

get '/player_hit' do
	game = session[:game]
	@player_name = session[:player_name]

	game.player_deal_a_card(@player_name)
	@dealer_cards = game.get_dealer_cards
	@player_cards = game.get_player_cards(@player_name)

	@status = get_result(1)

	@player_can_continue = @status == 0 ? true : false

	erb :display_cards
end

get '/player_stay' do
	game = session[:game]
	@player_name = session[:player_name]

	game.dealer_play
	@dealer_cards = game.get_dealer_cards
	@player_cards = game.get_player_cards(@player_name)

	@status = get_result(2)

	@player_can_continue = false

	erb :display_cards

end



