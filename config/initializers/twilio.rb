TWILIO_CONFIG = YAML.load_file(Rails.root.join('config', 'twilio.yml')) 
TWILIO_CLIENT = Twilio::REST::Client.new TWILIO_CONFIG['TWILIO_SID'], TWILIO_CONFIG['TWILIO_TOKEN'] 

