class ApplicationController < ActionController::Base
  protect_from_forgery

  #around_filter :global_request_logging  #Disabled for now, can reenable if needed
  def global_request_logging 
    http_request_header_keys = request.headers.keys.select{|header_name| header_name.match("^HTTP.*")}
    http_request_headers = request.headers.select{|header_name, header_value| http_request_header_keys.index(header_name)}
    logger.info "Received #{request.method.inspect} to #{request.url.inspect} from #{request.remote_ip.inspect}.  Processing with headers #{http_request_headers.inspect} and params #{params.inspect}"
    begin 
      yield 
    ensure 
      logger.info "Responding with #{response.status.inspect} => #{response.body.inspect}"
    end 
  end 
end
