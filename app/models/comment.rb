class Comment < ActiveRecord::Base
  belongs_to :quote
  validates_presence_of :commenter_name
  validates_presence_of :comment_text
end
