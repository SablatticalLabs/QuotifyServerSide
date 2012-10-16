class TestMailer < ActionMailer::Base

  def test_email(to)
    mail(:to => to, :from =>"\"Rob\" <rob@quotify.it>", :subject => "Quotify is now live")
  end
end
