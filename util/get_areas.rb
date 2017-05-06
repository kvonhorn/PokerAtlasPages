# Get a listing of all the PokerAtlas areas as json


require 'selenium-webdriver'
require_relative '../areas_page'
require 'json'

@driver_quit_called = false # Has @driver.quit been called?

# Set up Chrome
chromedriver_path = Selenium::WebDriver::Chrome.driver_path=`which chromedriver`.chomp
#puts "Using chromedriver at #{chromedriver_path}"

capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  'chromeOptions' => {
    "args" => [ "--headless", "--disable-gpu" ]
  }
)

at_exit do
  @driver.quit unless @driver.nil? or @driver_quit_called
end


# Get the /areas page
@driver = Selenium::WebDriver.for :chrome, desired_capabilities: capabilities
areas_page = AreasPage.new @driver
areas_page.get  # Load the /areas page

# Scrape the data and print out as JSON
areas_out = areas_page.get_areas
puts JSON.pretty_generate(areas_out)


@driver.quit
@driver_quit_called = true