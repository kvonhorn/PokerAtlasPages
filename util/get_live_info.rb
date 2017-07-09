# Get the live info off of a poker-room/.../cash-game page
# TODO: Update this to support other rooms

require_relative '../poker_room_page.rb'
require 'json'


# Set up Chrome
chromedriver_path = Selenium::WebDriver::Chrome.driver_path=`which chromedriver`.chomp
#puts "Using chromedriver at #{chromedriver_path}"

capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  'chromeOptions' => {
    "args" => [ "--headless", "--disable-gpu" ]
  }
)

@driver_quit_called = false
at_exit do
  @driver.quit unless @driver.nil? or @driver_quit_called
end


# Load the poker room page
@driver = Selenium::WebDriver.for :chrome, desired_capabilities: capabilities
#poker_room_name = 'red-hawk-casino-placerville'
poker_room_name = 'bicycle-casino-bell-gardens'
poker_room_page = PokerRoomPage.new @driver, "/poker-room/#{poker_room_name}"
poker_room_page.get


# Get all the data
live_info = poker_room_page.get_live_info
puts JSON.pretty_generate(live_info)


@driver.quit
@driver_quit_called = true