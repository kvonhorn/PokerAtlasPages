# PageObject for the poker-rooms page (e.g. http://www.pokeratlas.com/poker-rooms/sacramento).

require_relative 'pokeratlas_page'
require 'selenium-webdriver'


class PokerRoomsPage < PokerAtlasPage

  @@room_listing_li = 'li.venues-list-item'
  @@poker_room_name = '.venue-name'
  @@poker_room_uri = 'div.venue a'
  
  @@poker_room_live_header = 'a div.live-header'
  @@has_cash_icon = 'li.active i.cash-games'
  @@has_tournaments_icon = 'li.active i.tournaments'
  @@num_tables = 'span.count'
  
  
  # This will go to the default region(prob LA or LV); to set a particular
  # region, pass in a baseurl of the form '/poker-rooms/sacramento'.
  def initialize(driver, baseurl="/poker-rooms/los-angeles")
    super(driver, baseurl)
  end
  
  
  def get_poker_room_names
    poker_room_names_out = []
    
    poker_rooms = @driver.find_elements(:css, @@room_listing_li)
    poker_rooms.each do |poker_room|
      poker_room_name = poker_room.find_element(:css, @@poker_room_name).text
      poker_room_names_out.push poker_room_name
    end
    
    poker_room_names_out
  end


  def get_poker_rooms
    poker_rooms_out = Hash.new { |hash, key| hash[key] = {} }
    
    poker_rooms = @driver.find_elements(:css, @@room_listing_li)
    poker_rooms.each do |poker_room|
      poker_room_name = poker_room.find_element(:css, @@poker_room_name).text
      
      coordinates = PokerRoomsPage.get_venue_coordinates(poker_room).join(', ')
      poker_rooms_out[poker_room_name][:coordinates] = coordinates
      
      url = poker_room.find_element(:css, @@poker_room_uri).attribute('href')
      poker_rooms_out[poker_room_name][:url] = url
        
      num_tables = poker_room.find_element(:css, @@num_tables).text
      poker_rooms_out[poker_room_name][:num_tables] = num_tables
      
      poker_rooms_out[poker_room_name][:has_live_table_info] = PokerRoomsPage.has_live_table_info(poker_room)
      
      poker_rooms_out[poker_room_name][:has_cash_games] = PokerRoomsPage.has_cash_games(poker_room)
      
      poker_rooms_out[poker_room_name][:has_tournaments] = PokerRoomsPage.has_tournaments(poker_room)
    end
    
    poker_rooms_out
  end
  

  private
  
  def self.get_venue_coordinates(room_listing_li)
    coords_out = []
    coords_out.push room_listing_li.attribute('data-latitude')
    coords_out.push room_listing_li.attribute('data-longitude')
    coords_out
  end
  
  def self.has_elements(li, selector)
    li.find_elements(:css, selector).length > 0
  end
  
  def self.has_live_table_info(room_listing_li)
    PokerRoomsPage.has_elements(room_listing_li, @@poker_room_live_header)
  end
  
  def self.has_cash_games(room_listing_li)
    PokerRoomsPage.has_elements(room_listing_li, @@has_cash_icon)
  end
  
  def self.has_tournaments(room_listing_li)
    PokerRoomsPage.has_elements(room_listing_li, @@has_tournaments_icon)
  end
end