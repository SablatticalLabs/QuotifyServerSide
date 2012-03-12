class QuoteMailer < ActionMailer::Base
  default from: "quotes@quotify.it"
  
  def quote_email(quote)
    @quote = quote
    #TODO: Add in checks here that we have valid email addresses for quotifier and witnesses, and add them to the "TO" list
    mail(:to => quote.quotifier.email, :subject => "Remember When Your Friend Said This?")
  end
end
