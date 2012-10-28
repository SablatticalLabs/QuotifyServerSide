class CommentMailer < ActionMailer::Base
  default from: "reply@quotify.it"

  def comment_email(comment, to_user)
    @comment = comment
    @personalized_quote_id = comment.quote.personalized_quote_id_for(to_user)
    mail(:to => to_user.email, :from =>"\"Quotify.it\" <reply@quotify.it>", :subject => "There's A New Comment on #{comment.quote.speaker.name}'s Quote!")
  end
end
