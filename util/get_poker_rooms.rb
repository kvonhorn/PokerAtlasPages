# Get the poker rooms in a particular area (by default, Los Angeles).
# TODO: Update this to generate rooms in other areas

require_relative '../poker_rooms_page'
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


# Load the default poker rooms page
@driver = Selenium::WebDriver.for :chrome, desired_capabilities: capabilities
poker_rooms_page = PokerRoomsPage.new @driver
poker_rooms_page.get


# Get all the data
poker_rooms = poker_rooms_page.get_poker_rooms
puts JSON.pretty_generate(poker_rooms)


@driver.quit
@driver_quit_called = true