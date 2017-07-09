# Occasionally, a modal will appear asking the user to enter their email.
# This mixin will allow a user to detect the dialog and close it.


module SubscribeModal

  @@close_button = 'button.modal-close' # The close (X) icon of the dialog
  
  
  def initialize(driver, baseurl='/')
    super(driver, baseurl)
  end
  
  
  def close_subscribe_modal_if_visible
    close_buttons = @driver.find_elements(:css, @@close_button)
    close_buttons[0].click if close_buttons.length > 0 and close_buttons[0].displayed?
  end
end