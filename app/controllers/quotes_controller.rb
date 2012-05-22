class QuotesController < ApplicationController
  
  respond_to :html, :json
  
  # GET /quotes/1
  # GET /quotes/1.json
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  # POST /quotes
  # POST /quotes.json
  def create
    #Look up the speaker, quotifier, and witnesses - if they don't exist yet, then create them anew
    speaker = User.find_or_create(params[:quote][:speaker])  
    quotifier = User.find_or_create(params[:quote][:quotifier]) 
    witnesses = params[:quote][:witnesses].map {|witness| User.find_or_create(witness)} if params[:quote][:witnesses] 
    quote_time = params[:quote][:time] || Time.now

    #Set the randomly scheduled time to send the email to some point in the future.  
    #TODO: Make this a longer interval once done with testing, and also ensure that messages are only sent during normal daytime hours for texts
    #This is currently only set to go up to an 8 hour random range.  We will eventually make this longer.
    email_send_scheduled_time = params[:quote][:email_send_scheduled_time] || Time.now + rand( 60 * 60 * 8)
    email_sent_flag = params[:quote][:email_sent_flag] || false

    @quote = Quote.new(:quote_text => params[:quote][:quote_text], :quote_time => quote_time, :speaker => speaker, :quotifier => quotifier, 
                       :witnesses => (witnesses || []),:location => params[:quote][:location], :coordinate=>params[:quote][:coordinate],
                       :email_send_scheduled_time => email_send_scheduled_time , :email_sent_flag => email_sent_flag)

    flash[:notice] = 'Quote was successfully created' if @quote.save

    #If the speaker doesn't have an email address, we need to text them to ask them their phone number
    if speaker.email.blank?
      TWILIO_CLIENT.account.sms.messages.create(
        :from => TWILIO_PHONE_NUMBER,
        :to => speaker.phone,
        :body => "Your friend #{quotifier.name} just Quotified you!  Reply to this text with your email address to be kept in the loop!"
      )    
    end

    respond_with (@quote)
  end

end
