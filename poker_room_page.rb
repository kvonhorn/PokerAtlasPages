# Page Object for a particular poker room (e.g. http://www.pokeratlas.com/poker-room/red-hawk-casino-placerville)

require_relative 'pokeratlas_page'
require_relative 'live_info_panel'
require 'selenium-webdriver'


class PokerRoomPage < PokerAtlasPage
  
  @@cash_games_tab = '#cash-games-tab'
  
  def initialize(driver, baseurl='/poker-room')
    super(driver, baseurl)
  end
  
  
  def click_cash_games_tab
    self.click_tab(@@cash_games_tab)
  end
  
  
  def get
    super
    self.handle_mixins
  end
  
  protected
  
  # Mix in various modules depending on which panels are displayed
  def handle_mixins
    self.extend LiveInfoPanel if LiveInfoPanel.displayed?(@driver) and not self.is_a? LiveInfoPanel
    # TODO: Add a remove_module methods to remove methods added by module
    #self.remove_module LiveInfoPanel if not LiveInfoPanel.displayed?(@driver) and self.is_a? LiveInfoPanel
    # TODO: Update to support Cash Games Offered panel under Cash Games tab
  end
  
  def click_tab(tab_to_click)
    @driver.find_element(:css, tab_to_click).click
    self.handle_mixins    # Handle mixins whenever a tab is clicked
  end
  
end