class Quote < ActiveRecord::Base
  include UuidHelper  #Use 6-character string as ID
  before_create :set_uuid
  self.primary_key = 'id'

  belongs_to :speaker, :class_name => "User", :foreign_key => "speaker_user_id"
  belongs_to :quotifier, :class_name => "User", :foreign_key => "quotifier_user_id"
  has_many :quote_witness_users
  has_many :witnesses, :through => :quote_witness_users
  has_many :quote_images
  validates_presence_of :quotifier, :speaker, :quote_text
  validates_associated :quotifier, :speaker

  scope :ready_to_send_message, where("messages_sent_flag = ? and messages_send_scheduled_time < ?", false, Time.now)

  #Send out email, or if we only have phone number, send text message, to quotifier, speaker, and witnesses
  def send_messages
    QuoteMailer.quotifier_email(self).deliver

    unless speaker.email.blank?
      QuoteMailer.speaker_email(self).deliver
    else
      send_twillio_message(speaker.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{id}")
    end

    witnesses.each do |witness|
      unless witness.email.blank?
        QuoteMailer.witness_email(self, witness).deliver
      else
       send_twillio_message(witness.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{id}")
      end
    end

    #Set flag that messaging has been sent.
    self.messages_sent_flag = true
    self.save
  end

  private
  def send_twillio_message(phone, msg)
    begin
      TWILIO_CLIENT.account.sms.messages.create(
          :from => TWILIO_PHONE_NUMBER,
          :to => phone,
          :body => msg
        )    
    rescue Twilio::REST::RequestError
      false
    end
    true
  end

end
