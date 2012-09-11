class QuoteMailer < ActionMailer::Base
  default from: "reply@quotify.it"
  
  def quotifier_email(quote)
    @quote = quote
    mail(:to => quote.quotifier.email, :from =>"\"Quotify.it\" <reply@quotify.it>", :subject => "#{quote.speaker.name}'s Quote Has Arrived")

  end

  def speaker_email(quote)
    @quote = quote
    mail(:to => quote.speaker.email, :from =>"\"Quotify.it\" <reply@quotify.it>", :subject => "#{quote.quotifier.name} Quotified You!")
  end

  def witness_email(quote, witness, quote_witness)
    @quote = quote
    @quote_witness = quote_witness
    mail(:to => witness.email, :from =>"\"Quotify.it\" <reply@quotify.it>", :subject => "#{quote.quotifier.name} Tagged You In A Quote!")
  end

end
