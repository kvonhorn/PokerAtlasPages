# Models the /areas page on PokerAtlas.

require_relative 'pokeratlas_page'


class AreasPage < PokerAtlasPage
  
  @@state_div = 'div.state'
  @@state_name = 'div.state h3'
  @@area_name = 'div a'   # <a href='/sacramento'>Sacramento</a>
  
  @@country_div = 'div.country'
  @@country_name = 'div.country h2'
  
  
  def initialize(driver, baseurl='/areas')
    super(driver, baseurl)
  end
  
  
  # Return a dict of all the area baseurls keyed by state/provence
  # { 'California' => [ { 'Sacramento' => '/sacramento' },
  #                     { 'Los Angeles' => '/los-angeles' }, ... ],
  #   'Aruba' =>      [ { 'Aruba' => '/aruba' } ] } # This is an International area
  def get_areas
    areas_out = Hash.new { |hash, key| hash[key] = [] }
    
    
    ## Parse the International section
    country_divs = @driver.find_elements(:css, @@country_div)
    
    country_divs.each do |country_div|
      country_name = country_div.find_element(:css, @@country_name).text
      next unless country_name == 'International'
      #puts country_div.attribute('innerHTML')
      
      areas = country_div.find_elements(:css, @@area_name)
      areas.each do |area|
        area_name = area.text
        areas_out[area_name].push({area_name => area.attribute('href')})
      end
    end
    
    
    ## Parse the states and provinces
    state_divs = @driver.find_elements(:css, @@state_div)
    #puts "Found #{state_divs.length} divs"

    state_divs.each do |state_div|
      #puts state_div.attribute('innerHTML')
      state_name = state_div.find_element(:css, @@state_name).text
      state_areas = state_div.find_elements(:css, @@area_name)
    
      state_areas.each do |state_area|
        area_name = state_area.text
        area_path = state_area.attribute('href')
        areas_out[state_name].push({ area_name => area_path })
      end
      
    end

    areas_out
  end
end
