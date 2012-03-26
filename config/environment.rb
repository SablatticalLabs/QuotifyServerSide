# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Quotify::Application.initialize!

#Set up ActionMailer For SendGrid
ActionMailer::Base.smtp_settings = {
:user_name => "quotify_it",
:password => "NsO2Cnox",
:domain => "quotify.it",
:address => "smtp.sendgrid.net",
:port => 587,
:authentication => :plain,
:enable_starttls_auto => true
}
