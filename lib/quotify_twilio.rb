class QuotifyTwilio

  def self.send_twilio_message(phone, msg)
    begin
      TWILIO_CLIENT.account.sms.messages.create(
          :from => TWILIO_PHONE_NUMBER,
          :to => phone,
          :body => msg
        )    
    rescue Twilio::REST::RequestError => error_message
      error_message.to_s
    else
      'Success'
    end
  end

end