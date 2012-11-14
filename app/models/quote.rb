class Quote < ActiveRecord::Base
  include UuidHelper  #Use 6-character string as ID
  before_create :set_uuid
  before_create :set_user_quote_ids 
  before_save :remove_same_user_listed_more_than_once
  self.primary_key = 'id'

  belongs_to :speaker, :class_name => "User", :foreign_key => "speaker_user_id"
  belongs_to :quotifier, :class_name => "User", :foreign_key => "quotifier_user_id"
  has_many :quote_witness_users
  has_many :witnesses, :through => :quote_witness_users
  has_many :quote_images
  has_many :comments
  validates_presence_of :quotifier, :speaker, :quote_text
  validates_associated :quotifier, :speaker

  #This is the User object for the accessing user
  attr_accessor :accessing_user_obj
 
  scope :not_deleted, where("deleted = ? or deleted is null", false)
  scope :ready_to_test_for_dupes, where(" created_at > ?" , 6.hours.ago ).merge(Quote.not_deleted)
  scope :ready_to_send_message, where("messages_sent_flag = ? and messages_send_scheduled_time < ?", false, Time.now).merge(Quote.not_deleted)
  

  def is_deletable?
    if (self.created_at + 1.day > Time.now) && accessing_user_role == :quotifier then true else false end
  end

  #Send out email, or if we only have phone number, send text message, to quotifier, speaker, and witnesses
  def send_messages
    QuoteMailer.quotifier_email(self).deliver
    send_errors = []

    #If the person quotified themselves speaking, dont want to send two messages
    unless speaker.same_person_as(quotifier)
      unless speaker.email.blank?
        QuoteMailer.speaker_email(self).deliver
      else
        send_status = QuotifyTwilio.send_twilio_message(speaker.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{speaker_quote_id}")
        send_errors << send_status unless send_status == 'Success'
      end
    end

    quote_witness_users.each do |quote_witness|
      witness  = quote_witness.witness
      unless witness.email.blank?
        QuoteMailer.witness_email(self, witness, quote_witness).deliver
      else
       send_status = QuotifyTwilio.send_twilio_message(witness.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{quote_witness.witness_quote_id}")
       send_errors << send_status unless send_status == 'Success'
      end
    end

    #Set flag that messaging has been sent.
    self.messages_sent_flag = true
    self.error_flag = ! (send_errors.empty?)
    self.error_string = send_errors.join(',')
    self.save
  end

  def deleteDupes
    Rails.logger.debug "checking for deleted quotes on  " + self.id

    quotes = Quote.where( " quote_text = ? AND id != ? AND created_at >= ? " , self.quote_text, self.id, self.created_at )
    Rails.logger.debug "deleting " + quotes.length.to_s + " objs "
    quotes.each do | quote |     
      Rails.logger.debug "deleting ID " + quote.id
      quote.deleted = 1
      quote.save
      end

  end


  #The JSON returned for a quote should include details on the speaker 
  def as_json(options={})
    super(:include => [:speaker], :methods => [:is_deletable?, :personalized_quote_id])
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

  def self.find_by_any_id(id)
    if quote = Quote.find_by_id(id) then quote.tap {|q| q.accessing_user_obj = nil} 
    elsif quote = Quote.find_by_quotifier_quote_id(id) then quote.tap{|q| q.accessing_user_obj = quote.quotifier} 
    elsif quote = Quote.find_by_speaker_quote_id(id) then  quote.tap{|q| q.accessing_user_obj =  quote.speaker} 
    elsif quote = ((qwu = QuoteWitnessUser.find_by_witness_quote_id(id)) ? qwu.quote : nil) then quote.tap{|q| q.accessing_user_obj = qwu.witness} 
    end

  end

  def personalized_quote_id
    if accessing_user_role == :quotifier then quotifier_quote_id
    elsif accessing_user_role == :speaker then speaker_quote_id
    elsif accessing_user_role == :witness
      QuoteWitnessUser.find_by_quote_id_and_user_id(self.id, accessing_user_obj).witness_quote_id
    end
  end

  def personalized_quote_id_for(user)
    if user == self.quotifier then return self.quotifier_quote_id
    elsif user == self.speaker then return self.speaker_quote_id
    else 
      quote_witness_users.each do |qwu|
        return qwu.witness_quote_id if user == qwu.witness
      end
    end
    return nil  #If we got here, there was no match
  end

  #Determine the role of the user who is accessing the quote.  This is important for things like deletability.
  def accessing_user_role
    if self.accessing_user_obj.nil? then nil
    elsif self.quotifier == accessing_user_obj then :quotifier
    elsif self.speaker == accessing_user_obj then :speaker
    else witnesses.each {|witness| if witness == accessing_user_obj then return :witness end}
    end
  end

  private


  def remove_same_user_listed_more_than_once
    self.witnesses.delete_if do |witness|
      self.quotifier.same_person_as(witness) || self.speaker.same_person_as(witness)
    end
  end

end

