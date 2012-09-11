
class QuotesController < ApplicationController
  
  respond_to :html, :json

  # @see http://www.arctickiwi.com/blog/mobile-enable-your-ruby-on-rails-site-for-small-screens
  private
  MOBILE_BROWSERS = ["android", "ipod", "opera mini", "iphone", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]
  public

  def detect_browser
    agent = request.headers["HTTP_USER_AGENT"].downcase

    MOBILE_BROWSERS.each do |m|
      return "mobile_application" if agent.match(m)
    end
    return "application"
  end

  
  # GET /quotes/1 - 
  # GET /quotes/1.json - Used by iPhone
  def show
   @quote = Quote.find_by_any_id(params[:id])


    Mpanel.track("View Quote", { :user=> request.remote_ip , :id => params[:id] })
    Rails.logger.warn detect_browser
    respond_to do |format|
      if( detect_browser == 'mobile_application' || params[ :test_mobile ] == "1"  ) 
         template = "quotes/show_mobile.html.erb" ;
      else
         template = "quotes/show.html.erb" ;
      end
      format.html { render :template => template }
      format.json { render json: @quote }
    end
  end

  #Called by a DELETE HTTP call to /quotes/:id
  def destroy
    quote = Quote.find(params[:id])
    if quote.is_deletable? then
      quote.deleted = true
      quote.save
      render json: { deleted: true}
    else
      render json: { deleted: false, error: "Quote is not deletable"}
    end
  end


  # GET Called from iPhone to get history for a given email address
  def history
    users = User.find_all_by_email_case_insensitive(params[:email])
    @quotes = []
    users.each { |user| @quotes |= user.quotified_quotes.merge(Quote.not_deleted) }

    Mpanel.track("View History", { :user=> request.remote_ip , :email => params[:email] })

    respond_to do |format|
      format.json { render json: {quote_history: @quotes.sort{|a,b| b.created_at <=> a.created_at} }}
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
