class CommentsController < ApplicationController

  #All methods need to get a reference to the parent quote
  before_filter { |controller| @quote = Quote.find(params[:quote_id]) }

 def create
   @comment = Comment.create(params[:comment].merge(quote_id: @quote.id))
   render :json => @comment
 end


end
