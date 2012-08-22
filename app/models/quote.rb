class Quote < ActiveRecord::Base
  include UuidHelper  #Use 6-character string as ID
  before_create :set_uuid
  before_create :set_user_quote_ids 
  self.primary_key = 'id'

  belongs_to :speaker, :class_name => "User", :foreign_key => "speaker_user_id"
  belongs_to :quotifier, :class_name => "User", :foreign_key => "quotifier_user_id"
  has_many :quote_witness_users
  has_many :witnesses, :through => :quote_witness_users
  has_many :quote_images
  validates_presence_of :quotifier, :speaker, :quote_text
  validates_associated :quotifier, :speaker

  scope :ready_to_send_message, where("messages_sent_flag = ? and messages_send_scheduled_time < ?", false, Time.now)
  scope :not_deleted, where("deleted = ? or deleted is null", false)

  def is_deletable?
    self.created_at + 1.day > Time.now 
  end

  #Send out email, or if we only have phone number, send text message, to quotifier, speaker, and witnesses
  def send_messages
    QuoteMailer.quotifier_email(self).deliver
    send_errors = []

    unless speaker.email.blank?
      QuoteMailer.speaker_email(self).deliver
    else
      send_status = send_twillio_message(speaker.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{id}")
      send_errors << send_status unless send_status == 'Success'
    end

    witnesses.each do |witness|
      unless witness.email.blank?
        QuoteMailer.witness_email(self, witness).deliver
      else
       send_status = send_twillio_message(witness.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{id}")
       send_errors << send_status unless send_status == 'Success'
      end
    end

    #Set flag that messaging has been sent.
    self.messages_sent_flag = true
    self.error_flag = ! (send_errors.empty?)
    self.error_string = send_errors.join(',')
    self.save
  end

  #The JSON returned for a quote should include details on the speaker 
  def as_json(options={})
    super(:include => [:speaker], :methods => [:is_deletable?])
  end

  def set_user_quote_ids
    self.quotifier_quote_id = Quote.get_unique_quote_id
    self.speaker_quote_id = Quote.get_unique_quote_id  
  end


  #We are going to keep unique surrogate Quote IDs for each quote for each user so when they come back we know who they are by 
  #virtue of the link.  So, need a way to generate these quickly.
  def self.get_unique_quote_id
    possible_id = Base64.encode64(UUIDTools::UUID.random_create)[0..7]
    until Quote.where("quotes.id = ? or quotes.quotifier_quote_id = ? or quotes.speaker_quote_id = ? or quote_witness_users.witness_quote_id = ?", possible_id,possible_id,possible_id,possible_id).joins(:quote_witness_users).empty?
      possible_id = Base64.encode64(UUIDTools::UUID.random_create)[0..7]
    end
    possible_id
  end

  private
  def send_twillio_message(phone, msg)
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

