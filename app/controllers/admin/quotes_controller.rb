class Admin::QuotesController < ApplicationController
  layout 'admin'
  
  http_basic_authenticate_with :name => "quotify", :password => "yourmom1" 
  
  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.order("quote_time desc")

    Mpanel.track("Admin Main Page View", { :user=> request.remote_ip })

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.json
  def new
    @quote = Quote.new
    @quote.quotifier = User.new
    @quote.speaker = User.new

    Mpanel.track("New Quote Via Admin", { :user=> request.remote_ip })

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

 # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
  end


  # PUT /quotes/1
  # PUT /quotes/1.json
  def update
    @quote = Quote.find(params[:id])
    speaker = User.find_or_create(params[:quote][:speaker])
    quotifier = User.find_or_create(params[:quote][:quotifier])
    messages_send_scheduled_time = if params[:schedule_in_past_flag] then Date.yesterday else @quote.messages_send_scheduled_time end 

    Mpanel.track("Update Quote Via Admin", { :user=> request.remote_ip })

    respond_to do |format|
      if @quote.update_attributes(params[:quote].except(:speaker, :quotifier).merge({:speaker=>speaker, :quotifier=>quotifier, :messages_send_scheduled_time => messages_send_scheduled_time}))
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

    Mpanel.track("Delete Quote Via Admin", { :user=> request.remote_ip })

    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :ok }
    end
  end

  def send_messages_now

    Mpanel.track("Send Messages Via Admin", { :user=> request.remote_ip , :quote_id => params[:quote_id] })

    @quote = Quote.find(params[:quote_id])
    @quote.send_messages
    redirect_to action: "index"
  end

end
