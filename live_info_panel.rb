# Mixin to support Live Updates on a page
# TODO: Does this need to be in its own file? Could I just put this in poker_room.rb?

module LiveInfoPanel
  
  @@live_info_panel = '.live-info-panel'
  @@cash_game_row = 'tr.live-cash-game'
  @@last_updated = 'td.last-update'
  
  def get_live_info
    live_info_out = {}
    
    live_infos = @driver.find_elements(:css, @@live_info_panel)
    return nil if live_infos.length == 0
    
    # Get cash game info
    live_info = live_infos[0]
    cash_game_rows = live_info.find_elements(:css, @@cash_game_row)
    cash_game_rows.each do |cash_game_row|
      tds = cash_game_row.find_elements(:css, 'td')
      name = tds[0].text
      running = tds[1].text
      wait_list = tds[2].text
      live_info_out[name] = {:running => running, :wait_list => wait_list }
    end
    
    # Get the last updated info
    last_updated_texts = live_info.find_elements(:css, @@last_updated)
    last_updated = nil
    if last_updated_texts.length > 0
      last_updated = last_updated_texts[0].text
      last_updated.sub!(/[Ll]ast [Uu]pdated?\ *:\ */, '')
    end
    live_info_out['last_updated'] = last_updated
    
    live_info_out
  end
  
  def self.displayed?(driver)
    driver.find_elements(:css, @@live_info_panel).length > 0
  end
end