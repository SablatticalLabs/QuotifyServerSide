class CommentsController < ApplicationController

  #All methods need to get a reference to the parent quote
  before_filter { |controller| @quote = Quote.find(params[:quote_id]) }

  def create 
    @comment = Comment.new(params[:comment].merge(quote_id: @quote.id))
    save_success = @comment.save
    
    if save_success
      @comment.send_messages
    end

    respond_to do |format|
      if save_success
        format.html { redirect_to request.referrer, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created }
      else
        format.html { redirect_to request.referrer, notice: "Comment save had errors: #{@comment.errors.to_s}." }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
 
  def new
    @comment = Comment.new
  end

end
