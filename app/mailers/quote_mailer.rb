class QuoteMailer < ActionMailer::Base
  default from: "reply@quotify.it"
  
  def quotifier_email(quote)
    @quote = quote
    mail(:to => quote.quotifier.email, :subject => "Your Quote Has Arrived")
  end

  def speaker_email(quote)
    @quote = quote
    mail(:to => quote.speaker.email, :subject => "#{quote.quotifier.name} Quotified You!")
  end

  def witness_email(quote, witness)
    @quote = quote
    mail(:to => witness.email, :subject => "#{quote.quotifier.name} Included You In A Quote!")
  end

end
