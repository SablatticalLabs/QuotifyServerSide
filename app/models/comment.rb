class Comment < ActiveRecord::Base
  belongs_to :quote
  belongs_to :user
  validates_presence_of :commenter_name
  validates_presence_of :comment_text


  def send_messages
    #Message is not sent to the commenter himself, just to everyone else. 

    CommentMailer.comment_email(self, self.quote.quotifier).deliver unless self.quote.quotifier == self.user

    send_erorrs = []

    #If the person quotified themselves speaking, dont want to send two messages.  Also don't send message to person who left the comment.
    unless self.quote.speaker.same_email_or_phone_as(self.quote.quotifier) or self.quote.speaker == self.user
      unless self.quote.speaker.email.blank?
        CommentMailer.comment_email(self, self.quote.speaker).deliver
      else
        #TODO: Figure out setup for text messages
        #send_status = send_twillio_message(self.quote.speaker.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{speaker_quote_id}")
        #send_errors << send_status unless send_status == 'Success'
      end
    end

    self.quote.quote_witness_users.each do |quote_witness|
      witness  = quote_witness.witness
      unless witness == self.user
        unless witness.email.blank?
          CommentMailer.comment_email(self, witness).deliver
        else
         #TODO: Figure out setup for text messages
         #send_status = send_twillio_message(witness.phone, "#{quotifier.name} Quotified you!  Check it out at http://quotify.it/#{quote_witness.witness_quote_id}")
         #send_errors << send_status unless send_status == 'Success'
        end
      end
    end


  end

end
