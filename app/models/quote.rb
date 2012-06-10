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

  scope :ready_to_send_message, where("email_sent_flag = ? and email_send_scheduled_time < ?", false, Time.now)

  #Send out email, or if we only have phone number, send text message, to quotifier, speaker, and witnesses
  def send_messages
    QuoteMailer.quotifier_email(self).deliver

    unless speaker.email.blank?
      QuoteMailer.speaker_email(self).deliver
    else
      #SMS message
    end

    witnesses.each do |witness|
      unless witness.email.blank?
        QuoteMailer.witness_email(self, witness).deliver
      else
        #SMS message
      end
    end

    #Set flag that messaging has been sent.
    self.email_sent_flag = true
    self.save
  end

end
