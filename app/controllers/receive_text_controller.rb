class ReceiveTextController < ApplicationController
  def index

    message_body = params["Body"]
    from_number = params["From"]

    user = User.find_by_phone(from_number)
    user.email = message_body
    user.save

  end
end
