class QuoteImagesController < ApplicationController
  # GET /quote_images
  # GET /quote_images.json
  def index
    @quote = Quote.find(params[:quote_id])
    @quote_images = @quote.quote_images.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quote_images }
    end
  end

  # GET /quote_images/1
  # GET /quote_images/1.json
  def show
    @quote = Quote.find(params[:quote_id])
    @quote_image = QuoteImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote_image }
    end
  end

  # GET /quote_images/new
  # GET /quote_images/new.json
  def new
    @quote = Quote.find(params[:quote_id])
    @quote_image = QuoteImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote_image }
    end
  end

  # POST /quote_images
  # POST /quote_images.json
  def create
    @quote = Quote.find(params[:quote_id])
    @quote_image = QuoteImage.new(params[:quote_image])
    #@quote_image.save_file_to_server(params[:quote_image][:upload])

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
