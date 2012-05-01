class Admin::QuotesController < ApplicationController
  
  http_basic_authenticate_with :name => "quotify", :password => "yourmom1" 
  
  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.all

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
