class Admin::QuoteImagesController < ApplicationController
  http_basic_authenticate_with :name => "quotify", :password => "yourmom1" 
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

  # GET /quote_images/new
  def new
    @quote_image = QuoteImage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end


end
