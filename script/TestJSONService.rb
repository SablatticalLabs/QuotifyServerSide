require 'base64'
class QuoteService
  include HTTParty
  base_uri 'localhost:3000'
  headers  'ContentType' => 'application/json' ,'Accept' => 'application/json'
  format :json
end

#Test post to quote creation service
print QuoteService.post("/quotes/", :body => {"quote"=>{
                                                "quote_text"=>"Something Great",
                                                "quotifier"=>{"email"=>"sabag.lior@gmail.com"},
                                                "speaker"=>{"name"=>"Max Rosenblatt", "email"=>"maxrosenblatt@gmail.com"},
                                                "witnesses"=>["name"=>"Rob", "email"=>"rgoretsky@hotmail.com"],
                                                "time"=>"2011-12-04 00=>53",
                                                "mode"=>"quiet",
                                                "location"=>"Stockton St, San Francisco"}
                                             })

#Test get from quote image listing
#print QuoteService.post("/quotes/25/quote_images")

#Test POST to quote image creation service
#image = open("/home/rob/quotify/public/quote_images/6_d2dd0fd8.png", "rb") {|io| io.read }
#print QuoteService.post("/quotes/25/quote_images/", :body => {"quote_image" => { "name" => "JSON Test", "image_data" => Base64.encode64(image) }})

