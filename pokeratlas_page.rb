# The base page object for pages on PokerAtlas.

#require_relative 'subscribe_modal'
require 'addressable'


class PokerAtlasPage
  #include SubscribeModal
  
  @@url = "http://www.pokeratlas.com/"
  
  
  def initialize(driver, baseurl='/')
    @driver = driver
    @baseurl = baseurl
  end
  
  
  def get # Gets the page that this page object models
    page_to_get = Addressable::URI.parse(@@url).join(@baseurl).to_s
    @driver.get page_to_get
  end
end