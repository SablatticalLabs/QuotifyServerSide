class QuotesController < ApplicationController
  
  respond_to :html, :json
  
  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.json
  def new
    @quote = Quote.new
    @quote.quotifier = User.new
    @quote.speaker = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
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
    respond_with (@quote)
  end

  # PUT /quotes/1
  # PUT /quotes/1.json
  def update
    @quote = Quote.find(params[:id])
    speaker = User.find_or_create(params[:quote][:speaker])
    quotifier = User.find_or_create(params[:quote][:quotifier])

    respond_to do |format|
      if @quote.update_attributes(params[:quote].except(:speaker, :quotifier).merge({:speaker=>speaker, :quotifier=>quotifier}))
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :ok }
    end
  end

  def send_email_now
    @quote = Quote.find(params[:quote_id])
    QuoteMailer.quote_email(@quote).deliver
    redirect_to action: "index"
  end
end
