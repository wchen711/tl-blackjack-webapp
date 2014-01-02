# Week 1 Assignment
# Black Jack Game
# The Class hold deck(s) of cards

require_relative 'player'

class Game

  attr_accessor :decks, :dealer, :player_list

  def initialize
    @decks = Decks.new
    @dealer = Dealer.new("Dealer", 10_000)
    @player_list = []
  end
  
  def add_player(player_name)
    player = Player.new(player_name, 500)
    self.player_list << player
  end

  def deal_initial_hand
    get_initial_hand(dealer)
    player_list.each { |player| get_initial_hand(player)}
  end

  def finish_round
    decks.finish_round
    dealer.finish_round
    player_list.each { |player| player.finish_round }
  end
  
  def player_deal_a_card(player_name)
    player = find_player_by_name(player_name)
  	player.receive_a_card(decks.deal_a_card)
  end
  
  def dealer_play
  	while dealer.continue?
  		dealer.receive_a_card(decks.deal_a_card)
  	end
  end
  
  def get_dealer_total
  	dealer.total
  end
  
  def get_player_total(player_name)
  	player = find_player_by_name(player_name)
  	player.total
  end
  
  def dealer_21?
  	(dealer <=> 21) == 0 ? true : false
  end
  
  def player_21?(player_name)
    player = find_player_by_name(player_name)
  	(player <=> 21) == 0 ? true : false
  end

  def get_dealer_cards
    dealer.hand
  end

  def get_player_cards(player_name)
    player = find_player_by_name(player_name)
    player.hand
  end

  def display_game
    puts decks.to_s
    puts dealer.to_s
    player_list.each { |p| p.to_s }
  end


  
  private

  def find_player_by_name(player_name)
    if player_name == "Dealer"
      return dealer
    else
      player_ix = player_list.index { |p| p.name == player_name }
      return player_list[player_ix]
    end
  end
  
  def get_initial_hand(player)
    if player == nil
      return nil
    end
    player.receive_a_card(decks.deal_a_card)
    player.receive_a_card(decks.deal_a_card)
  end
  
end

