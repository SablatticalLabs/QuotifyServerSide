class ReceiveTextController < ApplicationController
  def index

    message_body = params["Body"]
    from_number = (params["From"])[2..20]   #Strip off "+1" at beginning

    user = User.find_by_phone(from_number)
    user.email = message_body
    user.save

    render :text => '<?xml version="1.0" encoding="UTF-8" ?>
                     <Response>
                       <Sms>Thank you!  Look for an email reconnecting you and your friends in the future!</Sms>
                     </Response>'
  end
end
