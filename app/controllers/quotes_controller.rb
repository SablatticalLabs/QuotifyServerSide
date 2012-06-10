class QuotesController < ApplicationController
  
  respond_to :html, :json
  
  # GET /quotes/1 - 
  # GET /quotes/1.json - Used by iPhone
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  # GET Called from iPhone to get history for a given email address
  def history
    user = User.find_by_email(params[:email])
    @quotes = user.quotified_quotes

    respond_to do |format|
      format.json { render json: {quote_history: @quotes }}
    end
  end

  # POST /quotes
  # POST /quotes.json
  def create
    #Look up the speaker, quotifier, and witnesses - if they don't exist yet, then create them anew
    #TO DO: User should be unique based on who is quotifying.  That way if kevin calls me 'dickwad', others dont see that.
    speaker = User.find_or_create(params[:quote][:speaker])  
    quotifier = User.find_or_create(params[:quote][:quotifier]) 
    witnesses = params[:quote][:witnesses].map {|witness| User.find_or_create(witness)} if params[:quote][:witnesses] 
    quote_time = params[:quote][:time] || Time.now

    #Set the randomly scheduled time to send the email and text messages to some point in the future.  
    #This is currently only set to go between 6 and 11 days after the message is received, at 2PM EST.
    messages_send_scheduled_time = Time.parse((Date.today + (rand(5) + 6).days).to_s + " 02:00PM") 
    messages_send_scheduled_time = Date.yesterday if params[:schedule_in_past_flag] 

    messages_sent_flag = params[:quote][:messages_sent_flag] || false

    @quote = Quote.new(:quote_text => params[:quote][:quote_text], :quote_time => quote_time, :speaker => speaker, :quotifier => quotifier, 
                       :witnesses => (witnesses || []),:location => params[:quote][:location], :coordinate=>params[:quote][:coordinate],
                       :messages_send_scheduled_time => messages_send_scheduled_time , :messages_sent_flag => messages_sent_flag)

    flash[:notice] = 'Quote was successfully created' if @quote.save

    respond_with (@quote)
  end

end
