class Comment < ActiveRecord::Base
  belongs_to :quote
  belongs_to :user
  validates_presence_of :commenter_name
  validates_presence_of :comment_text


  def send_messages
    #Message is not sent to the commenter himself, just to everyone else. 
    CommentMailer.comment_email(self, self.quote.quotifier).deliver unless self.quote.quotifier == self.user

    #If the person quotified themselves speaking, dont want to send two messages.  Also don't send message to person who left the comment.
    unless self.quote.speaker.same_person_as(self.quote.quotifier) or self.quote.speaker == self.user
      unless self.quote.speaker.email.blank?
        CommentMailer.comment_email(self, self.quote.speaker).deliver
      else
        QuotifyTwilio.send_twilio_message(self.quote.speaker.phone, "There's a new comment on #{self.quote.quotifier.name}'s quote!  Check it out at http://quotify.it/#{self.quote.speaker_quote_id}")
      end
    end

    self.quote.quote_witness_users.each do |quote_witness|
      witness  = quote_witness.witness
      unless witness == self.user
        unless witness.email.blank?
          CommentMailer.comment_email(self, witness).deliver
        else
          QuotifyTwilio.send_twilio_message(witness.phone, "There's a new comment on #{self.quote.quotifier.name}'s quote!  Check it out at http://quotify.it/#{quote_witness.witness_quote_id}")  
        end
      end
    end


  end

end
