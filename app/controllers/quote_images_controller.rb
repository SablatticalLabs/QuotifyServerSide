class QuoteImagesController < ApplicationController
  #All methods need to get a reference to the parent quote
  before_filter { |controller| @quote = Quote.find(params[:quote_id]) }

  # GET /quote_images
  # GET /quote_images.json
  def index
    @quote_images = @quote.quote_images.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quote_images }
    end
  end

  # GET /quote_images/1
  # GET /quote_images/1.json
  def show
    @quote_image = QuoteImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote_image }
    end
  end

  # GET /quote_images/new
  def new
    @quote_image = QuoteImage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /quote_images
  # POST /quote_images.json
  def create
    @quote_image = QuoteImage.new(params[:quote_image])

    respond_to do |format|
      if @quote_image.save
        format.html { redirect_to quote_quote_image_path(@quote, @quote_image), notice: 'Quote image was successfully created.' }
        format.json { render json: @quote_image, status: :created, location: @quote_image }
      else
        format.html { render action: "new" }
        format.json { render json: @quote_image.errors, status: :unprocessable_entity }
      end
    end
  end



end
