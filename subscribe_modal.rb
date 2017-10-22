# Occasionally, a modal will appear asking the user to enter their email.
# This mixin will allow a user to detect the dialog and close it.

# 2017-10-22: An ad was observed instead of the email subscribe modal. This
# mixin will now close all visible "close modal" buttons that are displayed,
# not just the email subscribe modal.


module SubscribeModal

  @@close_button = 'button.modal-close' # The close (X) icon of the dialog
  
  
  def initialize(driver, baseurl='/')
    super(driver, baseurl)
  end
  
  
  def close_subscribe_modal_if_visible
    close_buttons = @driver.find_elements(:css, @@close_button)
    close_buttons.each do |close_button|
      close_button.click if close_button.displayed?
    end
  end
end