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
    @quote = Quote.new(:quote_text => params[:quote][:quote_text], :quote_time => quote_time, :speaker => speaker, :quotifier => quotifier, 
                       :witnesses => (witnesses || []),:location => params[:quote][:location], :coordinate=>params[:quote][:coordinate])

    flash[:notice] = 'Quote was successfully created' if @quote.save
    respond_with (@quote)
  end

  # PUT /quotes/1
  # PUT /quotes/1.json
  def update
    @quote = Quote.find(params[:id])

    respond_to do |format|
      if @quote.update_attributes(params[:quote])
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
end
