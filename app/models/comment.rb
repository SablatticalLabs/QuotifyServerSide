class Comment < ActiveRecord::Base
  belongs_to :quote
  validates_presence_of :commenter_name
  validates_presence_of :comment_text
  before_create :set_email_sent_flag

  def set_email_sent_flag
    self.email_sent_flag = false
    true
  end
end
