class QuotesController < ApplicationController
  
  respond_to :html, :json
  
  # GET /quotes/1 - 
  # GET /quotes/1.json - Used by iPhone
  def show
    @quote = Quote.find(params[:id])


    Mpanel.track("View Quote", { :user=> request.remote_ip , :id => params[:id] })

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  # GET Called from iPhone to get history for a given email address
  def history
    users = User.find_all_by_email_case_insensitive(params[:email])
    @quotes = []
    users.each { |user| @quotes |= user.quotified_quotes }

    Mpanel.track("View History", { :user=> request.remote_ip , :email => params[:email] })

    respond_to do |format|
      format.json { render json: {quote_history: @quotes }}
    end
  end

  # POST /quotes
  # POST /quotes.json
  def create
    #TO DO: Right now, just creating a new user every time.  If we stick with this, then really dont need user model at all.  
    #If we do somehow look people up, need to make logic smarter somehow.


    speaker = User.create(params[:quote][:speaker])  
    quotifier = User.create(params[:quote][:quotifier]) 
    witnesses = params[:quote][:witnesses].map {|witness| User.create(witness)} if params[:quote][:witnesses] 
    quote_time = params[:quote][:time] || Time.now

    #Set the randomly scheduled time to send the email and text messages to some point in the future.  
    #This is currently only set to go between 6 and 11 days after the message is received, at 2PM EST.
    messages_send_scheduled_time = Time.parse((Date.today + (rand(5) + 6).days).to_s + " 02:00PM") 
    messages_send_scheduled_time = Date.yesterday if params[:schedule_in_past_flag] 

    Mpanel.track("Create Quote", { :user=> request.remote_ip , :speaker => params[:quote][:speaker], :quotifier => params[:quote][:quotifier] })

    messages_sent_flag = params[:quote][:messages_sent_flag] || false

    @quote = Quote.new(:quote_text => params[:quote][:quote_text], :quote_time => quote_time, :speaker => speaker, :quotifier => quotifier, 
                       :witnesses => (witnesses || []),:location => params[:quote][:location], :coordinate=>params[:quote][:coordinate],
                       :messages_send_scheduled_time => messages_send_scheduled_time , :messages_sent_flag => messages_sent_flag)

    flash[:notice] = 'Quote was successfully created' if @quote.save

    respond_with (@quote)
  end

end
